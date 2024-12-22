"""Merge sets of multiple Leuven files (stud.pal.3.44_1.xml,
stud.pal.3.44_2.xml, etc) into single files."""

from copy import deepcopy
from pathlib import Path
import re

from lxml import etree

from natsort import natsorted, ns


BASE_DIR = Path(
    "webapps/ROOT/content/xml/treebank/leuven")


def main():
    processed = []
    parser = etree.XMLParser(remove_blank_text=True)
    for path in BASE_DIR.glob("*.xml"):
        match = re.fullmatch(r"(.*)_\d+.xml", path.name)
        if match is not None:
            basename = match.group(1)
            if basename not in processed:
                process_basename(basename, parser)
                processed.append(basename)


def process_basename(basename, parser):
    base_tree = None
    for path in natsorted(BASE_DIR.glob("{}_*.xml".format(basename)),
                          alg=ns.PATH):
        if base_tree is None:
            base_tree = etree.parse(path, parser)
        else:
            extra_tree = etree.parse(path, parser)
            base_treebank = base_tree.getroot()
            for sentence in extra_tree.xpath("/treebank/sentence"):
                base_treebank.append(deepcopy(sentence))
    for idx, sentence in enumerate(base_tree.xpath("/treebank/sentence")):
        sentence.set("id", str(idx+1))
    with open(BASE_DIR / "{}.xml".format(basename), "wb") as fh:
        fh.write(etree.tostring(base_tree, encoding="utf-8",
                                pretty_print=True, xml_declaration=True))


if __name__ == "__main__":
    main()

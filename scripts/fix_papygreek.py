"""Process PapyGreek released files into a form that we want for KTB."""

from pathlib import Path
import unicodedata

from lxml import etree


ORIG_CORPUS_PATH = Path("../webapps/ROOT/content/xml/papygreek")
CORPUS_PATH = Path("../webapps/ROOT/content/xml/treebank/papygreek")
RENAMED_ATTRIBS = (
    "form",
    "head",
    "lemma",
    "postag",
    "relation",
)
UNWANTED_ATTRIBS = (
    "form_orig",
    "hand_id",
    "head_orig",
    "insertion_id",
    "lang",
    "lemma_orig",
    "line_n",
    "postag_orig",
    "relation_orig",
    "tm_word_id",
    "tp_n",
)


def main():
    parser = etree.XMLParser(remove_blank_text=True)
    for path in ORIG_CORPUS_PATH.glob("**/*.xml"):
        tree = etree.parse(path, parser)
        process_path(path.name, tree)


def process_path(basename, tree):
    for word in tree.xpath("/treebank/sentence/word"):
        for attrib in RENAMED_ATTRIBS:
            word.set(attrib, word.attrib.pop(attrib + "_reg", ""))
        orig_form = word.get("form_orig")
        if "~" in orig_form or "∼" in orig_form:
            short_orig_form = [
                letter for letter in unicodedata.normalize("NFC", orig_form)
                if unicodedata.category(letter)[0] == "L"]
            word.set("orig_form", "".join(short_orig_form))
            word.set("orig_postag", word.get("postag_orig"))
        for attrib in UNWANTED_ATTRIBS:
            word.attrib.pop(attrib, "")
    with open(CORPUS_PATH / basename, "wb") as fh:
        fh.write(etree.tostring(tree, encoding="utf-8", pretty_print=True,
                                xml_declaration=True))


if __name__ == "__main__":
    main()

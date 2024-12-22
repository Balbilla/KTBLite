"""Add original @form and @postag to PapyGreek documents."""

from pathlib import Path
import unicodedata

from lxml import etree


ORIG_CORPUS_PATH = Path("../webapps/ROOT/content/xml/orig_treebank")
CORPUS_PATH = Path("../webapps/ROOT/content/xml/treebank/papygreek")


def main():
    parser = etree.XMLParser(remove_blank_text=True)
    for path in CORPUS_PATH.glob("*.xml"):
        tree = etree.parse(path, parser)
        basename = path.name
        orig_tree = etree.parse(ORIG_CORPUS_PATH / ("orig_" + basename),
                                parser)
        process_work(tree, orig_tree, path)


def process_work(tree, orig_tree, path):
    for sentence in tree.xpath("/treebank/sentence"):
        sentence_id = sentence.get("id")
        for word in sentence:
            word_id = word.get("id")
            try:
                orig_word = orig_tree.xpath(
                    "/treebank/sentence[@id=$sentence_id]/word[@id=$word_id]",
                    sentence_id=sentence_id, word_id=word_id)[0]
            except IndexError:
                continue
            orig_form = orig_word.get("form", "")
            if "∼" in orig_form:
                short_orig_form = [letter for letter in unicodedata.normalize(
                    "NFC", orig_form) if unicodedata.category(letter)[0] == "L"]
                word.set("orig_form", "".join(short_orig_form))
                word.set("orig_postag", orig_word.get("postag"))
            else:
                word.attrib.pop("orig_form", "")
                word.attrib.pop("orig_postag", "")
    with open(path, "wb") as fh:
        fh.write(etree.tostring(tree, encoding="utf-8", pretty_print=True,
                                xml_declaration=True))


if __name__ == "__main__":
    main()

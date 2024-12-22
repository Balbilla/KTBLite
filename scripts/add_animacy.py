import csv
from pathlib import Path
import unicodedata

from lxml import etree


DATA_FILE = Path("animacy_data.tsv")
CORPUS_DIR = Path("../webapps/ROOT/content/xml/treebank/zleuven")


def main():
    animacy_map = get_animacy_map()
    update_corpora(animacy_map)


def get_animacy_map():
    print("Getting animacy data from file {}...".format(DATA_FILE))
    animacy_map = {}
    duplicates = []
    with open(DATA_FILE, encoding="utf-8", newline="") as csvfile:
        reader = csv.reader(csvfile, delimiter="\t")
        for row in reader:
            lemma = row[0]
            animacy_tag = row[1]
            if lemma in animacy_map and animacy_map[lemma] != animacy_tag:
                print("Warning: lemma '{}' is repeated; was '{}', now '{}'!".format(
                       lemma, animacy_map[lemma], animacy_tag))
                del animacy_map[lemma]
                duplicates.append(lemma)
            if lemma not in duplicates:
                if animacy_tag in ("person", "place") and has_initial_capital(
                        lemma):
                    continue
                animacy_map[lemma] = animacy_tag
    print("Generated animacy map.")
    return animacy_map


def update_corpora(animacy_map):
    for xml_file in CORPUS_DIR.glob("*.xml"):
        update_xml(animacy_map, xml_file)


def update_xml(animacy_map, xml_file):
    print("Updating {}.".format(xml_file))
    is_changed = False
    tree = etree.parse(xml_file)
    for word in tree.xpath(
            "//word[substring(@postag, 1, 1)='n']"):
        lemma = word.get("lemma")
        tag = animacy_map.get(lemma, None)
        if tag is None and has_initial_capital(lemma):
            tag = "name"
        if tag is not None:
            word.set("animacy", tag)
            is_changed = True
    if is_changed:
        with open(xml_file, "wb") as fh:
            fh.write(etree.tostring(tree, encoding="utf-8", pretty_print=True,
                                    xml_declaration=True))


def has_initial_capital(lemma):
    is_capital = False
    for char in unicodedata.normalize("NFD", lemma):
        category = unicodedata.category(char)
        if category.startswith("L"):
            if category == "Lu":
                is_capital = True
                break
            break
    return is_capital


if __name__ == "__main__":
    main()

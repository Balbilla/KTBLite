"""Convert Gorman's files from
https://github.com/vgorman1/Greek-Dependency-Trees into a form
suitable for KTB."""

import argparse
from copy import deepcopy
from pathlib import Path

from lxml import etree

from natsort import natsorted, ns


DESCRIPTION = "Convert files from Gorman's repository of trees into KTB-suitable files"
OUTPUT_HELP = "Directory to output assembled files to; must exist"
REPOSITORY_HELP = "Path to repository root directory of Gorman's trees"

# Mapping between output filename and input filename prefix
FILE_MAP = {
    "Aeschines_1": ["Aeschines 1"],
    "Antiphon_1": ["antiphon 1"],
    "Antiphon_2": ["antiphon 2"],
    "Antiphon_5": ["Antiphon 5"],
    "Antiphon_6": ["antiphon 6"],
    "Appian": ["Appian BC"],
    "Aristotle_Politics": ["Aristotle Politics"],
    "Athenaeus_12": ["athen12"],
    "Athenaeus_13": ["athen13"],
    "Demosthenes_1": ["Demosthenes 1"],
    "Demosthenes_4": ["Demosthenes 4"],
    "Demosthenes_18": ["demosthenes 18"],
    "Demosthenes_27": ["dem 27"],
    "Demosthenes_41": ["dem 41"],
    "Demosthenes_42": ["dem 42"],
    "Demosthenes_46": ["demosthenes 46"],
    "Demosthenes_47": ["demosthenes 47"],
    "Demosthenes 49": ["demosthenes 49"],
    "Demosthenes_50": ["demosthenes 50"],
    "Demosthenes_52": ["demosthenes 52"],
    "Demosthenes_53": ["demosthenes 53"],
    "Demosthenes_57": ["dem 57"],
    "Demosthenes_59": ["Dem 59"],
    "Diodorus_Sic": ["diodsic"],
    "Dionysius_Hal": ["dion hal"],
    "Herodotus": ["hdt"],
    "Josephus": ["josephus"],
    "Lysias_1": ["Lysias 1"],
    "Lysias_12": ["Lysias 12"],
    "Lysias_13": ["lysias 13"],
    "Lysias_14": ["Lysias 14"],
    "Lysias_15": ["lysias 15"],
    "Lysias_19": ["lysias 19"],
    "Lysias_23": ["Lysias 23"],
    "Plato_Apology": ["plato apology"],
    "Plato_Crito": ["Plato_Crito"],
    "Plutarch_Alcib": ["Plut Alcib"],
    "Plutarch_Alexander": ["plutarch alex"],
    "Plutarch_Fortuna": ["plut fortuna"],
    "Plutarch_Lycurgus": ["plutarch lycurgus"],
    "Polybius": ["polybius", "Polybius"],
    "Pseudo_Xenophon": ["ps xen"],
    "Thucydides": ["thuc"],
    "Xenophon_Hiero": ["Xenophon_Hiero"],
    "Xenophon_Cyrus": ["xen cyr", "xen_cyr"],
    "Xenophon_Hellenica": ["xen hell"],
    "Xenophon_Symposium": ["xen symp"],
}
FILENAME_TRANSLATION_TABLE = str.maketrans("_.", "--", " ")


def main():
    parser = argparse.ArgumentParser(description=DESCRIPTION)
    parser.add_argument("repository", help=REPOSITORY_HELP, metavar="REPO_DIR")
    parser.add_argument("output", help=OUTPUT_HELP, metavar="OUTPUT_DIR")
    args = parser.parse_args()
    source_dir = Path(args.repository) / "xml versions"
    output_dir = Path(args.output)
    seen_files = []
    xml_parser = etree.XMLParser(remove_blank_text=True)
    for full_name, prefixes in FILE_MAP.items():
        filename_map = generate_filename_map(source_dir, prefixes)
        source_filenames = natsorted(filename_map.keys(), alg=ns.PATH)
        seen_files.extend(
            process_files(source_filenames, filename_map, full_name,
                          output_dir, xml_parser))
    all_files = set([filename.name for filename in source_dir.glob("*.xml")])
    unseen_files = all_files - set(seen_files)
    if unseen_files:
        print("Files not converted by script (file map needs updating):")
        print("  {}".format("\n  ".join(unseen_files)))


def generate_filename_map(source_dir, prefixes):
    mapping = {}
    for prefix in prefixes:
        for filename in source_dir.glob("{}*.xml".format(prefix)):
            sortable_filename = prepare_filename(filename)
            mapping[sortable_filename] = filename
    return mapping


def prepare_filename(filename):
    """Return `filename` converted to a form that allows for correct
    natural sorting."""
    base = filename.name[:-4]
    base = base.replace("Polybius", "polybius")
    base = base.replace("polybius1 ", "polybius 1_")
    base = base.replace("polybius 6 ", "polybius 6_")
    base = base.replace("thuc 1 ", "thuc 1_")
    base = base.replace("xen_cyr_", "xen cyr ")
    return base.translate(FILENAME_TRANSLATION_TABLE)


def process_files(source_filenames, filename_map, full_name, output_dir,
                  xml_parser):
    base_tree = None
    seen_files = []
    #print("  {}".format(full_name))
    for filename in source_filenames:
        input_filename = filename_map[filename]
        #print("{}: {}".format(filename, filename_map[filename].name))
        if base_tree is None:
            base_tree = etree.parse(input_filename, xml_parser)
            for non_sentence in base_tree.xpath(
                    "/treebank/*[local-name() != 'sentence']"):
                non_sentence.getparent().remove(non_sentence)
        else:
            extra_tree = etree.parse(input_filename, xml_parser)
            base_treebank = base_tree.getroot()
            for sentence in extra_tree.xpath("/treebank/sentence"):
                base_treebank.append(deepcopy(sentence))
        seen_files.append(input_filename.name)
    for idx, sentence in enumerate(base_tree.xpath("/treebank/sentence")):
        sentence.set("id", str(idx+1))
    output_path = output_dir / "{}.xml".format(full_name)
    if output_path.exists():
        # Add in metadata from the existing file.
        old_tree = etree.parse(output_path, xml_parser)
        base_treebank = base_tree.getroot()
        try:
            metadata = old_tree.xpath("/treebank/metadata")[0]
            base_treebank.insert(0, deepcopy(metadata))
        except IndexError:
            pass
    with open(output_path, "wb") as fh:
        fh.write(etree.tostring(base_tree, encoding="utf-8", pretty_print=True,
                                xml_declaration=True))
    return seen_files


if __name__ == "__main__":
    main()

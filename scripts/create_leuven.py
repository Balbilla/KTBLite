"""Extract individual treebank files from the Duke-NLP grouped files."""

from copy import deepcopy
from pathlib import Path
import re

from lxml import etree

from natsort import natsorted, ns


DUKE_BASE_PATH = Path("../../duke-nlp/xml")
GENRES = [
    "Accounts", "Administration", "Contracts", "Declarations", "Letters",
    "Pronouncements", "Receipts", "Reports"
]
OUTPUT_PATH = Path("new-leuven")


def main():
    parser = etree.XMLParser(remove_blank_text=True)
    generate_initial_files(parser)
    merge_files(parser)


def copy_sentence(source_sentence, number, treebank):
    """Create a modified version of `sentence` and its descendants as a
    child of `treebank`."""
    sentence = etree.SubElement(treebank, "sentence")
    sentence.set("id", str(number))
    for source_word in source_sentence:
        word = etree.SubElement(sentence, "word")
        word.set("form", source_word.get("regularized"))
        word.set("head", source_word.get("head"))
        word.set("lemma", source_word.get("lemma"))
        orig_form = source_word.get("form", "")
        if "*" in orig_form:
            word.set("orig_form", orig_form.replace("*", ""))
        word.set("postag", source_word.get("postag"))
        word.set("relation", source_word.get("relation"))
        word.set("id", source_word.get("id"))
        if source_word.get("numeric_value") is not None:
            word.set("is_number", "true")


def create_new_treebank(sentence):
    date_not_before = get_year(int(sentence.get("period_min")),
                               is_minimum=True)
    date_not_after = get_year(int(sentence.get("period_max")),
                              is_minimum=False)
    genre = sentence.get("genre")
    place_name = sentence.get("place")
    root = etree.Element("treebank")
    document_meta = etree.SubElement(root, "document_meta")
    document_meta.set("date_not_before", date_not_before)
    document_meta.set("date_not_after", date_not_after)
    document_meta.set("place_name", place_name)
    hand_meta = etree.SubElement(root, "hand_meta")
    hand_meta.set("id", "1")
    hand_meta.set("name", "m1")
    text_type = etree.SubElement(hand_meta, "text_type")
    text_type.set("category", genre)
    return root


def generate_files(source_tree, seen_filenames, parser):
    previous_filename = None
    treebank = None
    sentence_count = 1
    for sentence in source_tree.xpath("/treebank/sentence"):
        filename = sentence.get("filename")
        output_filepath = get_output_filepath(filename)
        if filename != previous_filename:
            sentence_count = 1
            if previous_filename is not None:
                seen_filenames.append(previous_filename)
                previous_output_filepath = get_output_filepath(
                    previous_filename)
                save_tree(etree.ElementTree(treebank),
                          previous_output_filepath)
            if filename in seen_filenames:
                print("Reusing existing output file for {}".format(filename))
                treebank = etree.parse(output_filepath, parser).getroot()
                sentence_count = len(treebank.xpath("/treebank/sentence")) + 1
            else:
                treebank = create_new_treebank(sentence)
            previous_filename = filename
        copy_sentence(sentence, sentence_count, treebank)
        sentence_count += 1
    return seen_filenames


def generate_initial_files(parser):
    print("Generating initial files (no merged names)")
    seen_filenames = []
    for genre in GENRES:
        path_pattern = "Papyri_{}*.xml".format(genre)
        for source_path in DUKE_BASE_PATH.glob(path_pattern):
            print("Handling source file {}".format(source_path))
            source_tree = etree.parse(source_path, parser)
            seen_filenames = generate_files(source_tree, seen_filenames,
                                            parser)


def get_output_filepath(filename):
    return OUTPUT_PATH / "{}.xml".format(filename)


def get_year(period, is_minimum):
    """Return `period` converted into a year. This is done according to
    the completely wrong 'centuries' used by Trismegistos:
    https://www.trismegistos.org/calendar/cal_period_listcenturies.php

    >>> get_year(1, True)
    '1'
    >>> get_year(2, True)
    '100'
    >>> get_year(-1, True)
    '-99'
    >>> get_year(-2, True)
    '-199'
    >>> get_year(1, False)
    '99'
    >>> get_year(2, False)
    '199'
    >>> get_year(-1, False)
    '-1'
    >>> get_year(-2, False)
    '-100'

    """
    if is_minimum:
        if period == 1:
            date = 1
        elif period > 1:
            date = (period - 1) * 100
        else:
            date = period * 100 + 1
    else:
        if period > 0:
            date = period * 100 - 1
        elif period == -1:
            date = -1
        else:
            date = (period + 1) * 100
    return str(date)


def merge_basename_files(basename, parser):
    base_tree = None
    basename_paths = natsorted(OUTPUT_PATH.glob("{}_*.xml".format(basename)),
                               alg=ns.PATH)
    output_filepath = get_output_filepath(basename)
    if output_filepath.exists():
        print("Base file {} exists; merging partials into it: {}".format(
            basename, "; ".join([path.name for path in basename_paths])))
        base_tree = etree.parse(output_filepath, parser)
    for path in natsorted(basename_paths, alg=ns.PATH):
        if base_tree is None:
            base_tree = etree.parse(path, parser)
        else:
            extra_tree = etree.parse(path, parser)
            base_treebank = base_tree.getroot()
            for sentence in extra_tree.xpath("/treebank/sentence"):
                base_treebank.append(deepcopy(sentence))
    for idx, sentence in enumerate(base_tree.xpath("/treebank/sentence")):
        sentence.set("id", str(idx+1))
    save_tree(base_tree, output_filepath)
    for path in basename_paths:
        path.unlink()


def merge_files(parser):
    print("Merging files")
    processed = []
    for path in OUTPUT_PATH.glob("*.xml"):
        match = re.fullmatch(r"([^_]+)_.*.xml", path.name)
        if match is not None:
            basename = match.group(1)
            if basename not in processed:
                merge_basename_files(basename, parser)
                processed.append(basename)


def save_tree(tree, filepath):
    with open(filepath, "wb") as fh:
        fh.write(etree.tostring(tree, encoding="utf-8", pretty_print=True,
                                xml_declaration=True))


if __name__ == "__main__":
    import doctest
    doctest.testmod()
    main()

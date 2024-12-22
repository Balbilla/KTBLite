"""Generate an XLS document containing comparative data from the
overlap of Duke NLP and PapyGreek for a selected query.

The query is run twice, once for Leuven and once for PapyGreek
(overlap), and the output specifies the NP instances that overlap and the
NP instances that are unique to each corpus.

It does not currently mark the NP instances that are in both corpora
but in different counts (and so turn up as both overlap and unique!).

There are three sets of comparisons that each generate the above
results: matching form and text; matching form, text and at least one
position; and matching form, text and all positions. For comparisons
after the first, the output also includes: a list of items that have
been removed from the overlap result of the previous comparison; and a
list of new common items.

NOTA BENE: The list of items that have been removed from the overlap
result of the previous comparison may contain more items than the
difference in length between the new overlap and the previous overlap!
This is because there may be items in the new overlap that are not
present in the previous overlap. These are not genuinely new items,
but recombinations of Duke NLP and PapyGreek items.

Eg, we have:

Duke NLP 1: πόλει / πόλις / πόλει τῆς Θηβαίδος / postposed / p.mich.3.194
Duke NLP 2: πόλει / πόλις / ἐν Ὀξυρύγχων πόλει / preposed / p.mich.3.194

PapyGreek 1: πόλει / πόλις / ἐν Ὀξυρύγχων πόλει τῆς Θηβαίδος / preposed / p.mich.3.194
PapyGreek 2: πόλει / πόλις / ἐν Ὀξυρύγχων πόλει / preposed / p.mich.3.194

When comparing form and text, both these two instances overlap: Duke
NLP 1 with PapyGreek 1, Duke NLP 2 with PapyGreek 2.

When comparing form, text and positions, only one pair matches: Duke
NLP 2 with PapyGreek 1 (because it is the first matching item). This
means that in comparison, the new overlap has one less item, but there
are two pairs that are no longer new, and one new common pair. The
individual elements of the new common pair also occurred in the
previous common set, but not together, and that mismatch in pairing is
what causes these unintuitive results.

"""

import argparse
from copy import deepcopy

from lxml import etree

import pandas as pd

import requests


# CLI constants.
BASE_URL_HELP = "Base URL of search"
DEFAULT_BASE_URL = "http://localhost:9999/treebank/np-search.html"
DESCRIPTION = "Generate an Excel document containing comparative data from " \
    "Leuven and PapyGreek overlap for a selected query."
OUTPUT_HELP = "Path to output file (.xlsx)"
QUERY_CHOICES = {
    "ag": "np_ag_pos=n&word_is_proper_name=false&word_pos=Noun",
}
QUERY_HELP = "Query to run comparison for"

CORPORA = {
    "Duke NLP": {"corpus": "leuven_overlap"},
    "PapyGreek": {"corpus": "papygreek_overlap"},
}
POSITION_SEPARATOR = ", "


def main():
    parser = generate_parser()
    args = parser.parse_args()
    base_query_url = "{}?{}".format(args.base_url, QUERY_CHOICES[args.query])
    for corpus_data in CORPORA.values():
        perform_query(base_query_url, corpus_data)
    corpora = list(CORPORA.keys())
    corpus_a_title = corpora[0]
    corpus_b_title = corpora[1]
    corpus_a = CORPORA[corpora[0]]
    corpus_b = CORPORA[corpora[1]]
    comparators = {
        "Form": compare_form,
        "Single position": compare_position,
        "All positions": compare_positions,
    }
    with pd.ExcelWriter(args.output) as writer:
        previous_common = None
        for comparison_title, comparator in comparators.items():
            common_instances = perform_difference(
                corpus_a_title, corpus_a, corpus_b_title, corpus_b, comparator,
                comparison_title)
            write_data(writer, common_instances, corpus_a, corpus_a_title,
                       corpus_b, corpus_b_title, comparison_title,
                       previous_common)
            previous_common = common_instances


def compare_form(instance_a, instance_b):
    form_a = instance_a["form"]
    text_a = instance_a["text"]
    form_b = instance_b["form"]
    text_b = instance_b["text"]
    return form_a == form_b and text_a == text_b


def compare_position(instance_a, instance_b):
    positions_a = set(instance_a["positions"].split(POSITION_SEPARATOR))
    positions_b = set(instance_b["positions"].split(POSITION_SEPARATOR))
    return compare_form(instance_a, instance_b) and positions_a & positions_b


def compare_positions(instance_a, instance_b):
    positions_a = sorted(instance_a["positions"].split(POSITION_SEPARATOR))
    positions_b = sorted(instance_b["positions"].split(POSITION_SEPARATOR))
    return compare_form(instance_a, instance_b) and positions_a == positions_b


def format_phrase(phrase):
    words = phrase.split()
    return " ".join([word.split("-", maxsplit=1)[1] for word in words])


def generate_parser():
    parser = argparse.ArgumentParser(
        description=DESCRIPTION,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--base_url", default=DEFAULT_BASE_URL,
                        help=BASE_URL_HELP)
    parser.add_argument("query", choices=QUERY_CHOICES.keys(), help=QUERY_HELP)
    parser.add_argument("output", help=OUTPUT_HELP)
    return parser


def get_instance_copy(instance, title):
    return {"{} {}".format(title, key): value
            for key, value in instance.items()}


def perform_difference(corpus_a_title, corpus_a, corpus_b_title, corpus_b,
                       comparator, c_title):
    corpus_a[c_title] = []
    common_instances = []
    b_instances = deepcopy(corpus_b["instances"])
    for instance_a in corpus_a["instances"]:
        has_match = False
        for instance_b in b_instances:
            if comparator(instance_a, instance_b):
                copy_a = get_instance_copy(instance_a, corpus_a_title)
                copy_b = get_instance_copy(instance_b, corpus_b_title)
                copy_a.update(copy_b)
                common_instances.append(copy_a)
                b_instances.remove(instance_b)
                has_match = True
                break
        if not has_match:
            corpus_a[c_title].append(instance_a)
    corpus_b[c_title] = b_instances
    return common_instances


def perform_query(base_query_url, corpus_data):
    query_url = "{}&text_corpus={}&cocoon-view=content".format(
        base_query_url, corpus_data["corpus"])
    response = requests.get(query_url, timeout=1200)
    response.raise_for_status()
    tree = etree.ElementTree(etree.fromstring(response.content))
    rows = []
    for doc in tree.xpath("/aggregation/response/result/doc"):
        row_data = {}
        row_data["form"] = doc.xpath("str[@name='word_form']/text()")[0]
        row_data["lemma"] = doc.xpath("str[@name='word_lemma']/text()")[0]
        row_data["phrase"] = format_phrase(
            doc.xpath("str[@name='np_forms']/text()")[0])
        row_data["positions"] = POSITION_SEPARATOR.join(
            doc.xpath("arr[@name='np_ag_position']/str/text()"))
        row_data["text"] = doc.xpath("str[@name='text_name']/text()")[0]
        rows.append(row_data)
    corpus_data["instances"] = rows


def write_data(writer, common_instances, corpus_a, corpus_a_title, corpus_b,
               corpus_b_title, comparison_title, previous_common):
    corpus_a_df = pd.DataFrame(corpus_a[comparison_title])
    corpus_b_df = pd.DataFrame(corpus_b[comparison_title])
    common_df = pd.DataFrame(common_instances)
    corpus_a_df.to_excel(writer, sheet_name="{} {}".format(
        comparison_title, corpus_a_title), index=False)
    corpus_b_df.to_excel(writer, sheet_name="{} {}".format(
        comparison_title, corpus_b_title), index=False)
    common_df.to_excel(writer, sheet_name="{} Common".format(comparison_title),
                       index=False)
    if previous_common is not None:
        no_longer_common = [row for row in previous_common
                            if row not in common_instances]
        no_longer_df = pd.DataFrame(no_longer_common)
        new_common = [row for row in common_instances
                      if row not in previous_common]
        new_common_df = pd.DataFrame(new_common)
        no_longer_df.to_excel(writer, sheet_name="{} now not common".format(
            comparison_title), index=False)
        new_common_df.to_excel(writer, sheet_name="{} new common".format(
            comparison_title), index=False)


if __name__ == "__main__":
    main()

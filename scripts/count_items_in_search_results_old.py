import argparse
from collections import Counter

from lxml import etree

import requests


DESCRIPTION = "Create a count of each word occurring in a single field " \
    "in a set of search results."
FIELD_HELP = "Name of search field to count items "
OUTPUT_HELP = "Path to output file"
URL_HELP = "Search URL for results to count"


def main():
    parser = build_parser()
    args = parser.parse_args()
    url = "{}&cocoon-view=content".format(args.url)
    response = requests.get(url, timeout=1200)
    response.raise_for_status()
    tree = etree.ElementTree(etree.fromstring(response.content))
    field_content = []
    base_xpath = "/aggregation/response/result/doc/"
    for f in tree.xpath(base_xpath + "str[@name=$name]", name=args.field):
        field_content.extend(f.text.split())
    for f in tree.xpath(base_xpath + "arr[@name=$name]/str", name=args.field):
        field_content.append(f.text)
    c = Counter(field_content)
    with open(args.output, "w", encoding="utf-8") as fh:
        for item, count in c.most_common():
            fh.write("{}: {}\n".format(item, count))


def build_parser():
    parser = argparse.ArgumentParser(description=DESCRIPTION)
    parser.add_argument("url", metavar="URL", help=URL_HELP)
    parser.add_argument("field", metavar="FIELD", help=FIELD_HELP)
    parser.add_argument("output", metavar="OUTPUT", help=OUTPUT_HELP)
    return parser


if __name__ == "__main__":
    main()

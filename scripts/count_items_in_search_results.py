import argparse
from collections import Counter
import csv

from lxml import etree

import requests


DESCRIPTION = "Create a count of each word occurring in a single field " \
    "in a set of search results."
FIELD_HELP = "Name of search field to count items "
OUTPUT_HELP = "Path to output file"
PRECISION_HELP = "Digits of precision in percentage of total values"
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
    for f in tree.xpath(base_xpath + "str[@name=$name][normalize-space()]",
                        name=args.field):
        field_content.extend(f.text.split())
    for f in tree.xpath(base_xpath + "arr[@name=$name]/str[normalize-space()]",
                        name=args.field):
        field_content.append(f.text)
    c = Counter(field_content)
    total = c.total()
    with open(args.output, "w", encoding="utf-8", newline="") as fh:
        running_count = 0
        precision = args.precision
        writer = csv.writer(fh)
        writer.writerow(["Word", "Count", "Percentage of total",
                         "Cumulative percentage of total"])
        for item, count in c.most_common():
            running_count += count
            writer.writerow([
                item, count, round(count / total * 100, precision),
                round(running_count / total * 100, precision)])


def build_parser():
    parser = argparse.ArgumentParser(
        description=DESCRIPTION,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-p", "--precision", default=2, help=PRECISION_HELP,
                        metavar="PRECISION", type=int)
    parser.add_argument("url", help=URL_HELP, metavar="URL")
    parser.add_argument("field", help=FIELD_HELP, metavar="FIELD")
    parser.add_argument("output", help=OUTPUT_HELP, metavar="OUTPUT")
    return parser


if __name__ == "__main__":
    main()

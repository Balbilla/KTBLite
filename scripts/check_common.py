from pathlib import Path

from lxml import etree


BASE_DIR = Path("webapps/ROOT/content/xml/pp-tree")


def main():
    papygreek_files = (BASE_DIR / "papygreek_release_reg").glob("*.xml")
    count = 0
    for papygreek_file in papygreek_files:
        common_filename = papygreek_file.name
        p_metadata = get_metadata(str(papygreek_file))
        l_metadata = get_metadata(str(BASE_DIR / "leuven" / common_filename))
        if compare_metadata(common_filename, p_metadata, l_metadata):
            count += 1
    print("Mismatching documents: {}".format(count))


def compare_metadata(filename, papygreek, leuven):
    has_error = False
    for key, p_value in papygreek.items():
        l_value = leuven.get(key, "File not in leuven")
        if p_value != l_value:
            if not has_error:
                print(filename)
                has_error = True
            print("  {}: {} != {}".format(key, p_value, l_value))
    if has_error:
        print()
        return True
    return False


def get_metadata(filename):
    metadata = {}
    try:
        tree = etree.parse(filename)
    except OSError:
        return metadata
    metadata["genres"] = set(tree.xpath("/treebank/metadata/genres/genre/text()"))
    return metadata


if __name__ == '__main__':
    main()

"""Create a corpus consisting of those Leuven files that also exist in
PapyGreek, for the purposes of easy checking of Leuven's
treebanking."""

from pathlib import Path
import shutil


CORPUS_PATH = Path("../webapps/ROOT/content/xml/treebank")
LEUVEN_PATH = CORPUS_PATH / "zleuven"
PAPYGREEK_PATH = CORPUS_PATH / "papygreek"
LEUVEN_OVERLAP_PATH = CORPUS_PATH / "leuven_overlap"
PAPYGREEK_OVERLAP_PATH = CORPUS_PATH / "papygreek_overlap"


def main():
    LEUVEN_OVERLAP_PATH.mkdir(exist_ok=True)
    PAPYGREEK_OVERLAP_PATH.mkdir(exist_ok=True)
    for path in PAPYGREEK_PATH.glob("*.xml"):
        leuven_input_path = LEUVEN_PATH / path.name
        papygreek_input_path = PAPYGREEK_PATH / path.name
        if not leuven_input_path.exists():
            print("Warning: {} does not exist in Leuven corpus".format(
                path.name))
            continue
        leuven_output_path = LEUVEN_OVERLAP_PATH / path.name
        papygreek_output_path = PAPYGREEK_OVERLAP_PATH / path.name
        shutil.copy2(leuven_input_path, leuven_output_path)
        shutil.copy2(papygreek_input_path, papygreek_output_path)


if __name__ == "__main__":
    main()

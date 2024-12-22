"""Annotate words to indicate:

* presence of iota adscript
* ioticism in the word as a whole
* word ending mismatch

Do in this order to allow for progressive customisation of the
orig_form with equivalents.

"""

import logging
from pathlib import Path
import re
import unicodedata

from Bio import Align

import Levenshtein

from lxml import etree


CORPORA_DIR = Path("../webapps/ROOT/content/xml/treebank")
ENDING_LENGTH = 3
IOTA_ADSCRIPT_BASE_VOWELS = ["α", "η", "ω"]
IOTA_EQUIVALENTS = ["η", "υ", "οι", "ει", "ωι", "υι", "ι"]
IOTA_EQUIVALENTS_PATTERN = "({})".format("|".join(IOTA_EQUIVALENTS))
IOTA_EQUIVALENTS_PROG = re.compile(IOTA_EQUIVALENTS_PATTERN)
ORIG_WORDS_XPATH = "//word[normalize-space(@orig_form)]"


def main():
    for treebank_path in CORPORA_DIR.glob("papygreek/*.xml"):
        tree = Tree(treebank_path)
        tree.process_words()


class Tree:

    def __init__(self, treebank_path):
        self._path = treebank_path
        self._tree = etree.parse(treebank_path)

    def process_words(self):
        is_changed = False
        for word_element in self._tree.xpath(ORIG_WORDS_XPATH):
            next_word_id = int(word_element.get("id")) + 1
            try:
                next_word = word_element.xpath(
                    "ancestor::sentence//word[@id=$id]", id=next_word_id)[0]
            except IndexError:
                next_word = None
            word = Word(word_element, next_word)
            if word.process():
                is_changed = True
        if is_changed:
            with open(self._path, "wb") as fh:
                fh.write(etree.tostring(
                    self._tree, encoding="utf-8", pretty_print=True,
                    xml_declaration=True))


class Word:

    def __init__(self, word_element, next_word_element):
        self._word = word_element
        self._next_word = next_word_element
        self._has_changed = False
        postag = word_element.get("postag", "--------")
        try:
            self._pos = postag[0]
        except IndexError:
            self._pos = "-"
        try:
            self._case = postag[7]
        except IndexError:
            self._case = "-"

    def _annotate_ending(self, form, orig_form):
        # Ending_mismatch should only be checked for
        # words that have inflection, so we are excluding
        # all the rest.
        if self._pos in ("d", "c", "i", "r", "-"):
            return
        orig_ending = orig_form[-ENDING_LENGTH:]
        if orig_ending == form[-ENDING_LENGTH:]:
            return
        if (form == "υμειν" and orig_form == "υμιν") or \
           (form == "ημειν" and orig_form == "ημιν"):
            return
        if (form.endswith("αι") and orig_form.endswith("ε")) or \
           (form.endswith("ε") and orig_form.endswith("αι")):
            return
        if (form.endswith("αν") and orig_form.endswith("α")) or \
           (form.endswith("α") and orig_form.endswith("αν")):
            return
        orig_ending = orig_ending.replace("νπ", "μπ")
        orig_ending = orig_ending.replace("νψ", "μψ")
        orig_ending = orig_ending.replace("νφ", "μφ")
        orig_ending = orig_ending.replace("νγ", "γγ")
        pattern = self._generate_iotacism_pattern(orig_ending)
        if re.match(pattern, form) is None:
            self._word.set("ending-mismatch", "true")
            self._has_changed = True

    def _annotate_iota_adscript(self, form, orig_form, full_form):
        """
        >>> word = Word(etree.XML("<word/>"), etree.XML("<word/>"))
        >>> word._annotate_iota_adscript("και", "καμε", "καὶ")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("ευχομαι", "ευχωμε", "εὔχομαι")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("βασταχθηι", "βασταχθη", "βασταχθῆι")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("αφηιρηνται", "αφειρενται", "ἀφήιρηνται")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("αδελφηι", "αδελφην", "ἀδελφῆι")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("παλαιαν", "παλεαν", "παλαιάν")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("χρηιζω", "χρηζο", "χρήιζω")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("αδελφηι", "αδεφη", "ἀδελφῆι")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("επιζητηισ", "επιζετησ", "ἐπιζητῆισ")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("τραιανου", "τραειανου", "τραιανοῦ")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("πτολεμαικον", "πτολεμαεικον", "πτολεμαικὸν")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("βεβαιωσει", "βεβαωσι", "βεβαιωσει")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("ειδεναι", "ειδενα", "ειδεναι")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._case = "d"
        >>> word._annotate_iota_adscript("αρταβαισ", "αρταβασ", "ἀρτάβαισ")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._pos = "v"
        >>> word._annotate_iota_adscript("ναθλωμαι", "ναθλωμα", "ναθλῶμαι")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iota_adscript("θηβαικον", "θηβαεικον", "θηβαικὸν")
        >>> word._has_changed
        False

        """
        if not orig_form:
            return
        if form.startswith("τραιαν") or form.startswith("πτολεμαι") or \
           form.startswith("βεβαι"):
            return
        if form == "ειδεναι":
            return
        vowel_positions = []
        if form.endswith("αισ") and orig_form.endswith("ασ") and \
           self._case == "d":
            form = form[:-3]
            orig_form = orig_form[:-2]
        elif form.endswith("αι") and orig_form.endswith("α") and \
           self._pos == "v":
            form = form[:-2]
            orig_form = orig_form[:-1]
        for position, char in enumerate(form):
            if char in IOTA_ADSCRIPT_BASE_VOWELS and self._has_iota_adscript(
                    position, full_form):
                vowel_positions.append(position)
        if vowel_positions:
            aligner = Align.PairwiseAligner()
            alignments = aligner.align(form, orig_form)
            if all([self._alignment_shows_missing_iota_adscript(alignment, form, orig_form, vowel_positions) for alignment in alignments]):
                self._word.set("missing-iota-adscript", "true")
                self._has_changed = True

    def _alignment_shows_missing_iota_adscript(
            self, alignment, form, orig_form, positions):
        alignment_ranges = alignment.aligned[0]
        for position in positions:
            for index, alignment_range in enumerate(alignment_ranges):
                if position >= alignment_range[0] and \
                   position < alignment_range[1] and \
                   position + 1 >= alignment_range[1]:
                    # Further deal with case-ending changes that
                    # commonly occur to fuck things up.
                    if position == len(form) - 2 and \
                       form[position] in ["α", "η"] and \
                       orig_form[-1] in ["ν", "σ"]:
                        continue
                    if position == alignment_range[1] - 1 and \
                       form[position] == "α" and \
                       len(alignment.aligned[1]) > index + 1 and \
                       orig_form[alignment.aligned[1][index+1][0]] == "ι":
                        # When @form contains αι and @orig_form
                        # contains αει, this should not be counted as
                        # missing iota adscript. This requires
                        # checking that the alignment ends at the α
                        # and starts again with the ι.
                        continue
                    return True
        return False

    def _annotate_iotacism(self, form, orig_form, next_word=None):
        """
        >>> word = Word(etree.XML("<word/>"), etree.XML("<word/>"))
        >>> word._annotate_iotacism("ιτι", "ιτυ")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iotacism("ιτι", "ιτα")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iotacism("υγιαινειν", "υγιαινιν")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iotacism("ογι", "ι")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iotacism("ταιν", "τυειν")
        >>> word._has_changed
        True
        >>> word._has_changed = False
        >>> word._annotate_iotacism("ιτα", "ιτοι")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iotacism("υιωι", "υιου")
        >>> word._has_changed
        False
        >>> word._has_changed = False
        >>> word._annotate_iotacism("αυτον", "καιτον", etree.XML("<word postag='p-------' orig_form='|extra|'/>"))
        >>> word._has_changed
        True
        >>> word._word.get("krasis") == "true"
        True
        >>> word._has_changed = False
        >>> word._annotate_iotacism("περσηι", "περσησ")
        >>> word._has_changed
        False

        """
        if form[-2:] == "ωι" and orig_form[-2:] == "ου":
            form = form[:-2]
            orig_form = orig_form[:-2]
        base_distance = Levenshtein.distance(form, orig_form)
        if base_distance == 0:
            return
        # Krasis.
        if next_word is not None and next_word.get("orig_form") == "|extra|" \
           and next_word.get("postag")[0] not in ("u", "z"):
            self._word.set("krasis", "true")
            self._has_changed = True
            return
        logging.debug("{} -> {}: {}".format(orig_form, form, base_distance))
        for base in IOTA_EQUIVALENTS:
            pieces = orig_form.split(base)
            for i in range(1, len(pieces)):
                for equivalent in IOTA_EQUIVALENTS[:]:
                    if base == equivalent:
                        continue
                    equivalent_form = base.join(pieces[:i]) + equivalent + \
                        base.join(pieces[i:])
                    if len(base) == len(equivalent):
                        distance = base_distance
                        new_distance = Levenshtein.distance(
                            form, equivalent_form)
                        logging.debug("Base: {}    Equivalent: {}".format(
                            base, equivalent))
                        logging.debug("{} -> {}: {}".format(
                            equivalent_form, form, new_distance))
                    else:
                        # If we're dealing with a base that is a different
                        # length than the equivalent, we may get false
                        # positives when the @form is a different length
                        # than the @orig_form. Correct for this.
                        if len(base) == 2:
                            replaced = base
                        else:
                            replaced = equivalent
                        new_form = form.replace(replaced, "A")
                        new_orig_form = orig_form.replace(replaced, "A")
                        equivalent_form = equivalent_form.replace(
                            replaced, "A")
                        distance = Levenshtein.distance(
                            new_form, new_orig_form)
                        new_distance = Levenshtein.distance(
                            new_form, equivalent_form)
                        logging.debug("Base: {}    Equivalent: {}".format(
                            base, equivalent))
                        logging.debug("{} -> {}: {}".format(
                            new_orig_form, new_form, distance))
                        logging.debug("{} -> {}: {}".format(
                            equivalent_form, new_form, new_distance))
                    if new_distance < distance:
                        self._word.set("shows-iotacism", "true")
                        self._has_changed = True
                        return

    @staticmethod
    def _generate_iotacism_pattern(form):
        pattern = IOTA_EQUIVALENTS_PROG.sub(IOTA_EQUIVALENTS_PATTERN, form)
        return "^.*{}$".format(pattern)

    def _has_iota_adscript(self, position, form):
        """
        >>> word = Word(etree.XML("<word/>"), etree.XML("<word/>"))
        >>> word._has_iota_adscript(0, "μἧιν")
        False
        >>> word._has_iota_adscript(1, "μἧιν")
        True
        >>> word._has_iota_adscript(3, "μἧιν")
        False

        """
        try:
            if form[position + 1] == "ι":
                return True
        except IndexError:
            pass
        return False

    @staticmethod
    def _move_iota_subscript(form):
        """
        >>> word = Word(etree.XML("<word/>"), etree.XML("<word/>"))
        >>> word._move_iota_subscript("μᾗν")
        'μἧιν'

        """
        nfd_form = unicodedata.normalize("NFD", form.lower())
        moved_iota_subscript = nfd_form.replace("ͅ", "ι")
        return unicodedata.normalize("NFC", moved_iota_subscript)

    @staticmethod
    def _normalise_form(form):
        """Normalise `form` by removing all non-letter characters, and
        converting subscript iota to adscript iota.

        >>> word = Word(etree.XML("<word/>"), etree.XML("<word/>"))
        >>> word._normalise_form("μᾗν")
        'μηιν'

        """
        nfd_form = unicodedata.normalize("NFD", form.lower())
        chars = []
        for char in nfd_form:
            if unicodedata.category(char)[0] == "L":
                chars.append(char)
            elif char == "ͅ":
                chars.append("ι")
        return "".join(chars).replace("ς", "σ")

    def process(self):
        form = self._normalise_form(self._word.get("form", ""))
        full_form = self._move_iota_subscript(self._word.get("form", ""))
        orig_form = self._normalise_form(self._word.get("orig_form", ""))
        self._annotate_ending(form, orig_form)
        self._annotate_iota_adscript(form, orig_form, full_form)
        self._annotate_iotacism(form, orig_form, self._next_word)
        return self._has_changed


if __name__ == "__main__":
    import doctest
    doctest.testmod()
    main()

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">
  
  <!--  Things we do here:
    - "is-*" and "get-*" functions for every postag position and relation label
    -  is-* functions for proper name, patronym, substantive, vowel/diphthong
    - axes of dependency: first governor, first governing substantive, valid descent, agreement
    - metadata-related: date to century, genre, range, corpus selection   
    - variables used in multiple stylesheets.
    -->

  <xsl:variable name="pos-index" select="1"/>
  <xsl:variable name="person-index" select="2"/>
  <xsl:variable name="number-index" select="3"/>
  <xsl:variable name="tense-index" select="4"/>
  <xsl:variable name="mood-index" select="5"/>
  <xsl:variable name="voice-index" select="6"/>
  <xsl:variable name="gender-index" select="7"/>
  <xsl:variable name="case-index" select="8"/>
  <xsl:variable name="degree-index" select="9"/>

  <xsl:variable name="syllable-contour-ascending" select="'ascending'"/>
  <xsl:variable name="syllable-contour-descending" select="'descending'"/>
  <xsl:variable name="syllable-contour-plateau" select="'plateau'"/>
  <xsl:variable name="syllable-contour-ascending-plateau" select="'ascending-plateau'"/>
  <xsl:variable name="syllable-contour-descending-plateau" select="'descending-plateau'"/>
  <xsl:variable name="syllable-contour-mixed" select="'mixed'"/>
  <xsl:variable name="syllable-contour-none" select="'none'"/>
  <xsl:variable name="syllable-contour-single" select="'single'"/>

  <xsl:variable name="subtree-contour-single" select="'single'"/>
  <xsl:variable name="subtree-contour-plateau" select="'plateau'"/>
  <xsl:variable name="subtree-contour-ascending" select="'ascending'"/>
  <xsl:variable name="subtree-contour-descending" select="'descending'"/>
  <xsl:variable name="subtree-contour-mixed" select="'mixed'"/>
  
  <xsl:variable name="ag_position_internal" select="'internal'"/>
  <xsl:variable name="ag_position_postposed" select="'postposed'"/>
  <xsl:variable name="ag_position_preposed" select="'preposed'"/>
  
  <xsl:variable name="coordination-coordinated" select="'coordinated'"/>
  <xsl:variable name="coordination-juxtaposed" select="'juxtaposed'"/>
  <xsl:variable name="coordination-other" select="'other'"/>
  <xsl:variable name="coordination-punctuation" select="'punctuation'"/>
  
  <!-- Includes τις -->
  <xsl:variable name="old-quantifiers" select="(normalize-unicode('πᾶς'), normalize-unicode('ἅπας'), normalize-unicode('ὅλος'), normalize-unicode('μόνος'), 
    normalize-unicode('ἄλλος'), normalize-unicode('ἕτερος'), normalize-unicode('τις'))"/>
  
  <xsl:variable name="quantifiers" select="(
    normalize-unicode('ἄλλος'),
    normalize-unicode('ἅπας'),
    normalize-unicode('μόνος'),
    normalize-unicode('ὅλος'),
    normalize-unicode('ὀλίγος'),
    normalize-unicode('πᾶς'),
    normalize-unicode('σύμπας'),
    normalize-unicode('πλέως'),
    normalize-unicode('πολύς')
    )"/>
  
  <xsl:variable name="interrogatives" select="(
    normalize-unicode('πότερος'),
    normalize-unicode('τίς'),
    normalize-unicode('ποῖος'),
    normalize-unicode('πόσος')
    )"/>
  
  
  <xsl:variable name="old-demonstrative-adjectives" select="(normalize-unicode('ὅδε'), normalize-unicode('οὗτος'), normalize-unicode('ἐκεῖνος'), 
    normalize-unicode('τοιόσδε'), normalize-unicode('τοσόσδε'), normalize-unicode('τοιοῦτος'), normalize-unicode('τοσοῦτος'))"/>
  
  
  <!-- NB! There is some code in treebank-clean that converts ekeinos and outos to pronouns in pp! 
    If something ever breaks in the future, this is a potential culprit. 
    However, I'm leaving it here until I have a definitive stance on where they should be categorised,
    so as to avoid having to write the code again. -->
  <xsl:variable name="demonstrative-adjectives" select="(
    normalize-unicode('τοιοῦτος'),
    normalize-unicode('τοιόσδε'),
    normalize-unicode('τοσόσδε'),
    normalize-unicode('τοσοῦτος')
    )"/>
    
  <!-- We might want to do something about the different treatment of ι -->
  <xsl:variable name="vowels" select="('Α', 'ᾼ', 'Ε', 'Η', 'ῌ', 'Ι', 'Ο', 'Υ', 'Ω', 'ῼ', 'α', 'ᾳ', 'ε', 'η', 'ῃ', 'ι', 'ο', 'υ', 'ω', 'ῳ',
                                      normalize-unicode('Ὰ'), normalize-unicode('Ὲ'), normalize-unicode('Ὴ'), normalize-unicode('Ὶ'), normalize-unicode('Ὸ'), normalize-unicode('Ὺ'), normalize-unicode('Ὼ'),
                                      normalize-unicode('ὰ'), normalize-unicode('ᾲ'), normalize-unicode('ὲ'), normalize-unicode('ὴ'), normalize-unicode('ῂ'), normalize-unicode('ὶ'), normalize-unicode('ὸ'), normalize-unicode('ὺ'), normalize-unicode('ὼ'), normalize-unicode('ῲ'),
                                      normalize-unicode('Ά'), normalize-unicode('Έ'), normalize-unicode('Ή'), normalize-unicode('Ί'), normalize-unicode('Ό'), normalize-unicode('Ύ'), normalize-unicode('Ώ'),
                                      normalize-unicode('ά'), normalize-unicode('ᾴ'), normalize-unicode('έ'), normalize-unicode('ή'), normalize-unicode('ῄ'), normalize-unicode('ί'), normalize-unicode('ό'), normalize-unicode('ύ'), normalize-unicode('ώ'), normalize-unicode('ῴ'),
                                      normalize-unicode('ᾶ'), normalize-unicode('ᾷ'), normalize-unicode('ῆ'), normalize-unicode('ῇ'), normalize-unicode('ῖ'), normalize-unicode('ῦ'), normalize-unicode('ῶ'), normalize-unicode('ῷ'),
                                      normalize-unicode('Ἀ'), normalize-unicode('ᾈ'), normalize-unicode('Ἐ'), normalize-unicode('Ἠ'), normalize-unicode('ᾘ'), normalize-unicode('Ἰ'), normalize-unicode('Ὀ'), normalize-unicode('Ὠ'), normalize-unicode('ᾨ'),
                                      normalize-unicode('ἀ'), normalize-unicode('ᾀ'), normalize-unicode('ἐ'), normalize-unicode('ἠ'), normalize-unicode('ᾐ'), normalize-unicode('ἰ'), normalize-unicode('ὀ'), normalize-unicode('ὐ'), normalize-unicode('ὠ'), normalize-unicode('ᾠ'),
                                      normalize-unicode('Ἂ'), normalize-unicode('ᾊ'), normalize-unicode('Ἒ'), normalize-unicode('Ἢ'), normalize-unicode('ᾚ'), normalize-unicode('Ἲ'), normalize-unicode('Ὂ'), normalize-unicode('Ὢ'), normalize-unicode('ᾪ'),
                                      normalize-unicode('ἂ'), normalize-unicode('ᾂ'), normalize-unicode('ἒ'), normalize-unicode('ἢ'), normalize-unicode('ᾒ'), normalize-unicode('ἲ'), normalize-unicode('ὂ'), normalize-unicode('ὒ'), normalize-unicode('ὢ'), normalize-unicode('ᾢ'),
                                      normalize-unicode('Ἄ'), normalize-unicode('ᾌ'), normalize-unicode('Ἔ'), normalize-unicode('Ἤ'), normalize-unicode('ᾜ'), normalize-unicode('Ἴ'), normalize-unicode('Ὄ'), normalize-unicode('Ὤ'), normalize-unicode('ᾬ'),
                                      normalize-unicode('ἄ'), normalize-unicode('ᾄ'), normalize-unicode('ἔ'), normalize-unicode('ἤ'), normalize-unicode('ᾔ'), normalize-unicode('ἴ'), normalize-unicode('ὄ'), normalize-unicode('ὔ'), normalize-unicode('ὤ'), normalize-unicode('ᾤ'),
                                      normalize-unicode('Ἆ'), normalize-unicode('ᾎ'), normalize-unicode('Ἦ'), normalize-unicode('ᾞ'), normalize-unicode('Ἶ'), normalize-unicode('Ὦ'), normalize-unicode('ᾮ'),
                                      normalize-unicode('ἆ'), normalize-unicode('ᾆ'), normalize-unicode('ἦ'), normalize-unicode('ᾖ'), normalize-unicode('ἶ'), normalize-unicode('ὖ'), normalize-unicode('ὦ'), normalize-unicode('ᾦ'),
                                      normalize-unicode('Ἁ'), normalize-unicode('ᾉ'), normalize-unicode('Ἑ'), normalize-unicode('Ἡ'), normalize-unicode('ᾙ'), normalize-unicode('Ἱ'), normalize-unicode('Ὁ'), normalize-unicode('Ὑ'), normalize-unicode('Ὡ'), normalize-unicode('ᾩ'),
                                      normalize-unicode('ἁ'), normalize-unicode('ᾁ'), normalize-unicode('ἑ'), normalize-unicode('ἡ'), normalize-unicode('ᾑ'), normalize-unicode('ἱ'), normalize-unicode('ὁ'), normalize-unicode('ὑ'), normalize-unicode('ὡ'), normalize-unicode('ᾡ'),
                                      normalize-unicode('Ἃ'), normalize-unicode('ᾋ'), normalize-unicode('Ἓ'), normalize-unicode('Ἣ'), normalize-unicode('ᾛ'), normalize-unicode('Ἳ'), normalize-unicode('Ὃ'), normalize-unicode('Ὓ'), normalize-unicode('Ὣ'), normalize-unicode('ᾫ'),
                                      normalize-unicode('ἃ'), normalize-unicode('ᾃ'), normalize-unicode('ἓ'), normalize-unicode('ἣ'), normalize-unicode('ᾓ'), normalize-unicode('ἳ'), normalize-unicode('ὃ'), normalize-unicode('ὓ'), normalize-unicode('ὣ'), normalize-unicode('ᾣ'),
                                      normalize-unicode('Ἅ'), normalize-unicode('ᾍ'), normalize-unicode('Ἕ'), normalize-unicode('Ἥ'), normalize-unicode('ᾝ'), normalize-unicode('Ἵ'), normalize-unicode('Ὅ'), normalize-unicode('Ὕ'), normalize-unicode('Ὥ'), normalize-unicode('ᾭ'),
                                      normalize-unicode('ἅ'), normalize-unicode('ᾅ'), normalize-unicode('ἕ'), normalize-unicode('ἥ'), normalize-unicode('ᾕ'), normalize-unicode('ἵ'), normalize-unicode('ὅ'), normalize-unicode('ὕ'), normalize-unicode('ὥ'), normalize-unicode('ᾣ'),
                                      normalize-unicode('Ἇ'), normalize-unicode('Ἧ'), normalize-unicode('Ἷ'), normalize-unicode('Ὗ'),
                                      normalize-unicode('ἇ'), normalize-unicode('ᾇ'), normalize-unicode('ἧ'), normalize-unicode('ᾗ'), normalize-unicode('ἷ'), normalize-unicode('ὗ'), normalize-unicode('ὧ'), normalize-unicode('ᾧ'),
                                      normalize-unicode('Ᾰ'), normalize-unicode('Ῐ'), normalize-unicode('Ῠ'), normalize-unicode('Ᾱ'), normalize-unicode('Ῑ'), normalize-unicode('Ῡ'), normalize-unicode('Ϊ'), normalize-unicode('Ϋ'),
                                      normalize-unicode('ᾰ'), normalize-unicode('ῐ'), normalize-unicode('ῠ'), normalize-unicode('ᾱ'), normalize-unicode('ῑ'), normalize-unicode('ῡ'), normalize-unicode('ϊ'), normalize-unicode('ϋ'),
                                      normalize-unicode('ῒ'), normalize-unicode('ΐ'), normalize-unicode('ῗ'), normalize-unicode('ῢ'), normalize-unicode('ΰ'), normalize-unicode('ῧ'))"/>

  <xsl:variable name="diphthongs" select="(normalize-unicode('Αἰ'), normalize-unicode('Αἴ'), normalize-unicode('Αἲ'), normalize-unicode('Αἶ'),
                                          normalize-unicode('Αἱ'), normalize-unicode('Αἵ'), normalize-unicode('Αἳ'), normalize-unicode('Αἷ'),
                                          normalize-unicode('αι'), normalize-unicode('αί'), normalize-unicode('αὶ'), normalize-unicode('αῖ'),
                                          normalize-unicode('αἰ'), normalize-unicode('αἴ'), normalize-unicode('αἲ'), normalize-unicode('αἶ'),
                                          normalize-unicode('αἱ'), normalize-unicode('αἵ'), normalize-unicode('αἳ'), normalize-unicode('αἷ'),
                                          normalize-unicode('Εἰ'), normalize-unicode('Εἴ'), normalize-unicode('Εἲ'), normalize-unicode('Εἶ'),
                                          normalize-unicode('Εἱ'), normalize-unicode('Εἵ'), normalize-unicode('Εἳ'), normalize-unicode('Εἷ'),
                                          normalize-unicode('ει'), normalize-unicode('εί'), normalize-unicode('εὶ'), normalize-unicode('εῖ'),
                                          normalize-unicode('εἰ'), normalize-unicode('εἴ'), normalize-unicode('εἲ'), normalize-unicode('εἶ'),
                                          normalize-unicode('εἱ'), normalize-unicode('εἵ'), normalize-unicode('εἳ'), normalize-unicode('εἷ'),
                                          normalize-unicode('Οἰ'), normalize-unicode('Οἴ'), normalize-unicode('Οἲ'), normalize-unicode('Οἶ'),
                                          normalize-unicode('Οἱ'), normalize-unicode('Οἵ'), normalize-unicode('Οἳ'), normalize-unicode('Οἷ'),
                                          normalize-unicode('οι'), normalize-unicode('οί'), normalize-unicode('οὶ'), normalize-unicode('οῖ'),
                                          normalize-unicode('οἰ'), normalize-unicode('οἴ'), normalize-unicode('οἲ'), normalize-unicode('οἶ'),
                                          normalize-unicode('οἱ'), normalize-unicode('οἵ'), normalize-unicode('οἳ'), normalize-unicode('οἷ'),
                                          normalize-unicode('Υἰ'), normalize-unicode('Υἴ'), normalize-unicode('Υἲ'), normalize-unicode('Υἶ'),
                                          normalize-unicode('Υἱ'), normalize-unicode('Υἵ'), normalize-unicode('Υἳ'), normalize-unicode('Υἷ'),
                                          normalize-unicode('υι'), normalize-unicode('υί'), normalize-unicode('υὶ'), normalize-unicode('υῖ'),
                                          normalize-unicode('υἰ'), normalize-unicode('υἴ'), normalize-unicode('υἲ'), normalize-unicode('υἶ'),
                                          normalize-unicode('υἱ'), normalize-unicode('υἵ'), normalize-unicode('υἳ'), normalize-unicode('υἷ'),
                                          normalize-unicode('Ηἰ'), normalize-unicode('Ηἴ'), normalize-unicode('Ηἲ'), normalize-unicode('Ηἶ'),
                                          normalize-unicode('Ηἱ'), normalize-unicode('Ηἵ'), normalize-unicode('Ηἳ'), normalize-unicode('Ηἷ'),
                                          normalize-unicode('ηι'), normalize-unicode('ηί'), normalize-unicode('ηὶ'), normalize-unicode('ηῖ'),
                                          normalize-unicode('ηἰ'), normalize-unicode('ηἴ'), normalize-unicode('ηἲ'), normalize-unicode('ηἶ'),
                                          normalize-unicode('ηἱ'), normalize-unicode('ηἵ'), normalize-unicode('ηἳ'), normalize-unicode('ηἷ'),
                                          normalize-unicode('Ωἰ'), normalize-unicode('Ωἴ'), normalize-unicode('Ωἲ'), normalize-unicode('Ωἶ'),
                                          normalize-unicode('Ωἱ'), normalize-unicode('Ωἵ'), normalize-unicode('Ωἳ'), normalize-unicode('Ωἷ'),
                                          normalize-unicode('ωι'), normalize-unicode('ωί'), normalize-unicode('ωὶ'), normalize-unicode('ωῖ'),
                                          normalize-unicode('ωἰ'), normalize-unicode('ωἴ'), normalize-unicode('ωἲ'), normalize-unicode('ωἶ'),
                                          normalize-unicode('ωἱ'), normalize-unicode('ωἵ'), normalize-unicode('ωἳ'), normalize-unicode('ωἷ'),
                                          normalize-unicode('ῶι'), normalize-unicode('ωι'), 
                                          normalize-unicode('Αὐ'), normalize-unicode('Αὔ'), normalize-unicode('Αὒ'), normalize-unicode('Αὖ'),
                                          normalize-unicode('Αὑ'), normalize-unicode('Αὕ'), normalize-unicode('Αὓ'), normalize-unicode('Αὗ'),
                                          normalize-unicode('αυ'), normalize-unicode('αύ'), normalize-unicode('αὺ'), normalize-unicode('αῦ'),
                                          normalize-unicode('αὐ'), normalize-unicode('αὔ'), normalize-unicode('αὒ'), normalize-unicode('αὖ'),
                                          normalize-unicode('αὑ'), normalize-unicode('αὕ'), normalize-unicode('αὓ'), normalize-unicode('αὗ'),
                                          normalize-unicode('Εὐ'), normalize-unicode('Εὔ'), normalize-unicode('Εὒ'), normalize-unicode('Εὖ'),
                                          normalize-unicode('Εὑ'), normalize-unicode('Εὕ'), normalize-unicode('Εὓ'), normalize-unicode('Εὗ'),
                                          normalize-unicode('ευ'), normalize-unicode('εύ'), normalize-unicode('εὺ'), normalize-unicode('εῦ'),
                                          normalize-unicode('εὐ'), normalize-unicode('εὔ'), normalize-unicode('εὒ'), normalize-unicode('εὖ'),
                                          normalize-unicode('εὑ'), normalize-unicode('εὕ'), normalize-unicode('εὓ'), normalize-unicode('εὗ'),
                                          normalize-unicode('Οὐ'), normalize-unicode('Οὔ'), normalize-unicode('Οὒ'), normalize-unicode('Οὖ'),
                                          normalize-unicode('Οὑ'), normalize-unicode('Οὕ'), normalize-unicode('Οὓ'), normalize-unicode('Οὗ'),
                                          normalize-unicode('ου'), normalize-unicode('ού'), normalize-unicode('οὺ'), normalize-unicode('οῦ'),
                                          normalize-unicode('οὐ'), normalize-unicode('οὔ'), normalize-unicode('οὒ'), normalize-unicode('οὖ'),
                                          normalize-unicode('οὑ'), normalize-unicode('οὕ'), normalize-unicode('οὓ'), normalize-unicode('οὗ'),
                                          normalize-unicode('Ηὐ'), normalize-unicode('Ηὔ'), normalize-unicode('Ηὒ'), normalize-unicode('Ηὖ'),
                                          normalize-unicode('Ηὑ'), normalize-unicode('Ηὕ'), normalize-unicode('Ηὓ'), normalize-unicode('Ηὗ'),
                                          normalize-unicode('ηυ'), normalize-unicode('ηύ'), normalize-unicode('ηὺ'), normalize-unicode('ηῦ'),
                                          normalize-unicode('ηὐ'), normalize-unicode('ηὔ'), normalize-unicode('ηὒ'), normalize-unicode('ηὖ'),
                                          normalize-unicode('ηὑ'), normalize-unicode('ηὕ'), normalize-unicode('ηὓ'), normalize-unicode('ηὗ'))"/>

  <xsl:template name="label-by-number">
    <xsl:param name="number-code"/>
    <xsl:choose>
      <xsl:when test="$number-code = 's'">
        <xsl:text>Singular</xsl:text>
      </xsl:when>
      <xsl:when test="$number-code = 'p'">
        <xsl:text>Plural</xsl:text>
      </xsl:when>
      <xsl:when test="$number-code = 'd'">
        <xsl:text>Dual</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="label-by-pos">
    <xsl:param name="pos-code"/>
    <xsl:choose>
      <xsl:when test="$pos-code = 'a'">
        <xsl:text>Adjective</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'd'">
        <xsl:text>AdverbParticle</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'l'">
        <xsl:text>Article</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'c'">
        <xsl:text>Conjunction</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'i'">
        <xsl:text>Interjection</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'n'">
        <xsl:text>Noun</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'm'">
        <xsl:text>Numeral</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'r'">
        <xsl:text>Adposition</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'p'">
        <xsl:text>Pronoun</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'u'">
        <xsl:text>Punctuation</xsl:text>
      </xsl:when>
      <xsl:when test="$pos-code = 'v'">
        <xsl:text>Verb</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Unrecognised PoS code: </xsl:text>
        <xsl:value-of select="$pos-code"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="label-by-genitive-absolute-type">
    <xsl:param name="construction-type"/>
    <xsl:choose>
      <xsl:when test="$construction-type = '1'">
        <xsl:text>Type 1 - single participle governing single agent</xsl:text>
      </xsl:when>
      <xsl:when test="$construction-type = '2'">
        <xsl:text>Type 2 - single participle governing co-ordinated agents</xsl:text>
      </xsl:when>
      <xsl:when test="$construction-type = '3'">
        <xsl:text>Type 3 - co-ordinated participles sharing a single agent</xsl:text>
      </xsl:when>
      <xsl:when test="$construction-type = '4'">
        <xsl:text>Type 4 - co-ordinated participles governing co-ordinated agents</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="word" mode="display-word-pos-highlight">
    <span>
      <xsl:attribute name="class">
        <xsl:text>word-pos-</xsl:text>
        <xsl:value-of select="tb:get-pos(.)" />
      </xsl:attribute>
      <xsl:value-of select="@form" />
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:function name="tb:date-to-century" as="xs:string">
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="normalize-space($date) and number($date)">
        <xsl:variable name="century" select="floor(($date - 1) div 100)"/>
        <xsl:choose>
          <xsl:when test="$century &gt; -1">
            <xsl:value-of select="$century + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$century"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:agrees" as="xs:boolean">
    <xsl:param name="dependent"/>
    <xsl:param name="governor"/>
    <xsl:choose>
      <!-- Only check if genders match IF the governor has a gender specified -->
      <xsl:when test="normalize-space(tb:get-gender($governor)) and not(tb:get-gender($dependent) = tb:get-gender($governor))">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="not(tb:get-number($dependent) = tb:get-number($governor))">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="not(tb:get-case($dependent) = tb:get-case($governor))">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:get-case" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $case-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-case" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $case-index, 1)"/>
  </xsl:function>

  <xsl:function name="tb:get-gender" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $gender-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-gender" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $gender-index, 1)"/>
  </xsl:function>

  <!-- Gets the genre of a single treebank element -->
  <!-- Returns the first genre only! -->
  <xsl:function name="tb:get-genre" as="xs:string">
    <xsl:param name="treebank"/>
    <xsl:value-of select="$treebank/metadata/genres/genre[1]"/>
  </xsl:function>

  <!-- Gets the genres of the supplied treebank elements as a sequence -->
  <xsl:function name="tb:get-genres" as="xs:string*">
    <xsl:param name="treebanks"/>
    <xsl:sequence select="$treebanks/metadata/genres/genre"/>
  </xsl:function>

  <xsl:function name="tb:get-governing-substantive">
    <xsl:param name="word"/>
    <xsl:sequence select="$word/ancestor::word[tb:is-substantive(.)][1]"/>
  </xsl:function>
  
  <xsl:function name="tb:get-degree" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $degree-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-degree" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $degree-index, 1)"/>
  </xsl:function>

  <xsl:function name="tb:get-mood" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $mood-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-mood" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $mood-index, 1)"/>
  </xsl:function>

  <xsl:function name="tb:get-number" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $number-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-number" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $number-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-person" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $person-index, 1)"/>
  </xsl:function> 
  
  <xsl:function name="tb:get-orig-person" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $person-index, 1)"/>
  </xsl:function>

  <xsl:function name="tb:get-pos" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $pos-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-pos" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $pos-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-tense" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $tense-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-tense" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $tense-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-voice" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag, $voice-index, 1)"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-voice" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="substring($word/@postag_orig, $voice-index, 1)"/>
  </xsl:function>

  <xsl:function name="tb:get-relation" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="$word/@relation"/>
  </xsl:function>
  
  <xsl:function name="tb:get-orig-relation" as="xs:string">
    <xsl:param name="word"/>
    <xsl:value-of select="$word/@relation_orig"/>
  </xsl:function>
  
  <xsl:function name="tb:get-np-modifier-position">
    <xsl:param name="np-head"/>
    <xsl:param name="modifier-id"/>
    <xsl:variable name="head-id" select="xs:integer($np-head/@id)"/>
    <xsl:variable name="article-ids" select="tokenize($np-head/@article-ids, '\s+')"/>    
    <xsl:variable name="is-ds-participant" select="$np-head//word[@id = $modifier-id]/@ds-participant"/>
    <xsl:choose>
      <xsl:when test="exists($article-ids)">
        <xsl:variable name="article-id" select="xs:integer($article-ids[1])"/>
        <xsl:choose>
          <!-- DS: head - modifier -->
          <xsl:when test="$is-ds-participant = 'true' and $modifier-id &gt; $head-id">
            <xsl:text>postposed-ds</xsl:text>
          </xsl:when>
          <!-- DS: head - article - modifier -->
          <xsl:when test="$is-ds-participant = 'true' and $head-id &lt; $article-id and $article-id &lt; $modifier-id">
            <xsl:text>postposed-ds</xsl:text>
          </xsl:when>
          <!-- article - modifier - head -->
          <xsl:when test="$modifier-id &gt; $article-id and $modifier-id &lt; $head-id">
            <xsl:text>internal</xsl:text>
          </xsl:when>
          <!-- DS: modifier - head -->
          <xsl:when test="$is-ds-participant = 'true' and $modifier-id &lt; $head-id">
            <xsl:text>preposed-ds</xsl:text>
          </xsl:when>
          <!-- article - head - modifier -->
          <xsl:when test="$modifier-id &gt; $article-id and $modifier-id &gt; $head-id">
            <xsl:text>postposed</xsl:text>
          </xsl:when>
          <!-- head - modifier - article -->
          <xsl:when test="$modifier-id &lt; $article-id and $modifier-id &gt; $head-id">
            <xsl:text>postposed</xsl:text>
          </xsl:when>
          <!-- modifier - article - head -->
          <xsl:when test="$modifier-id &lt; $article-id and $modifier-id &lt; $head-id">                                
            <xsl:text>preposed</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>CHECK</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$modifier-id &lt; $head-id">
        <xsl:text>preposed</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>postposed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:get-span-words">
    <xsl:param name="subtree-head"/>
    <xsl:variable name="subtree-ids" select="$subtree-head/descendant-or-self::word[not(tb:is-artificial(.))]/@id" as="xs:integer*"/>
    <xsl:variable name="first" select="min($subtree-ids)"/>
    <xsl:variable name="last" select="max($subtree-ids)"/>
    <xsl:sequence select="$subtree-head/ancestor::sentence//word[@id &gt;= $first and @id &lt;= $last]"/>
  </xsl:function>
  
  <xsl:function name="tb:has-article" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:variable name="article-ids" as="xs:integer*">
      <xsl:for-each select="$word//word[tb:is-article-to-word(., $word)]" >
        <xsl:value-of select="xs:integer(@id)"/>
      </xsl:for-each>
      <xsl:for-each select="$word/parent::word/word[tb:is-article-to-word(., $word)]" >
        <xsl:value-of select="xs:integer(@id)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="count($article-ids) &gt; 0">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
    <!--<xsl:choose>
      <xsl:when test="$word/word[tb:is-article(.) and tb:agrees(., $word)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:get-mood($word) = 'n' and word[tb:is-article(.)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="$word/word[tb:is-adjective(.) and tb:agrees(., $word)]/word[tb:is-article(.) and tb:agrees(., $word)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>-->
  </xsl:function>
  
  <xsl:function name="tb:infinitive-has-article" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word[tb:is-verb($word) and tb:is-infinitive($word)]/word[tb:is-article(.) and tb:get-gender(.) = 'n']">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Shared article by coordinated infinitives -->
      <xsl:when test="$word[tb:is-verb($word) and tb:is-infinitive($word)]/parent::word/@id = $word/ancestor::sentence//word[tb:is-article(.) and tb:get-gender(.) = 'n']/parent::word/@id">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- xs:boolean means that it returns true or false -->
  <xsl:function name="tb:is-adjective" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'a'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-article-to-word" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:param name="target"/>
    <xsl:choose>
      <xsl:when test="not(tb:is-article($word))">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="tb:agrees($word, $target) and $word/parent::word/@id = $target/@id">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Shared article between coordinated heads, agreeing article -->
      <xsl:when test="tb:is-coordinator($word/parent::word) and 
        $word/parent::word/@id = $target/parent::word/@id and
        tb:agrees($word, $target)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- DS article -->
      <xsl:when test="tb:is-ds-article($word, $target)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Infinitive article. -->
      <xsl:when test="tb:get-gender($word) = 'n' and $word/parent::word/@id = $target/@id and
        tb:is-verb($target) and tb:is-infinitive($target)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Shared article between coordinated infinitives -->
      <xsl:when test="tb:is-coordinator($word/parent::word) and 
        tb:is-infinitive($target) and
        $word/parent::word/@id = $target/parent::word/@id">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Only for proper names -->
      <xsl:when test="tb:agrees($word, $target) and tb:is-name($target)
        and $word/parent::word[tb:get-relation(.) = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO') and tb:agrees(., $target)
        and tb:descends-directly-or-solely-via-coordinators(., $target)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-adverb" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="not(tb:is-particle($word)) and tb:get-pos($word) = 'd'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-article" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'l'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-artificial" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@artificial = 'elliptic'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- As PG's treatment of appositions and attributes is a little bit uncertain, APOS
    relations are added here to cover all grounds -->
  <xsl:function name="tb:is-attributive" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-relation($word) = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-attributive-participle" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word[tb:is-verb(.) 
        and tb:agrees(., tb:get-first-governor(.))
        and not(word[not(tb:is-article(.))])]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-auxiliary" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="substring(tb:get-relation($word), 1, 3) = 'Aux'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-conjunction" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'c'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-coordinator" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-relation($word) = 'COORD'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:descends-directly-or-solely-via-coordinators" as="xs:boolean">
    <!-- This includes the deprecated annotation style using punctuation or artificials as APOS heads. -->
    <!-- This function is the pair of tb:get-first-governor. If the logic of the code changes here, 
    the other one needs to be updated too! -->
    <xsl:param name="descendant"/>
    <xsl:param name="ancestor"/>
    <xsl:choose>
      <xsl:when test="$descendant/ancestor::word[not(tb:is-coordinator(.)) 
        and not((tb:is-punctuation(.) or tb:is-artificial(.)) and @relation=('APOS', 'APOS_CO'))][ancestor::word[@id = $ancestor/@id]]">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
  <!-- These are pure gaps, i.e. not containing any Greek -->
  <xsl:function name="tb:is-gap" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@is-gap = 'true'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:get-first-governor">
    <!-- This function is the pair of tb:descends-directly-or-solely-via-coordinators. 
      If the logic of the code changes here, the other one needs to be updated too! -->
    <xsl:param name="descendant"/>
    <xsl:sequence select="$descendant/ancestor::word[not(tb:is-coordinator(.)) 
      and not((tb:is-punctuation(.) or tb:is-artificial(.)) 
      and @relation=('APOS', 'APOS_CO'))][1]"/> 
  </xsl:function>
  
  <xsl:function name="tb:is-dative" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-case($word) = 'd'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Returns true if $word is an agreeing article separated from $target by an agreeing adjective -->
  <xsl:function name="tb:is-ds-article" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:param name="target"/>
    <xsl:choose>
      <xsl:when test="tb:is-article($word) and tb:agrees($word, $target) and $word/parent::word[tb:is-adjective(.) 
        and tb:agrees(., $target) and tb:descends-directly-or-solely-via-coordinators(., $target)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-dual" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-number($word) = 'd'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-emphasizer" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@relation = ('AuxZ', 'AuxZ_CO')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-feminine" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-gender($word) = 'f'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-genitive" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-case($word) = 'g'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-infinitive" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-mood($word) = 'n'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-interjection" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'i'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-masculine" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-gender($word) = 'm'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-mobile" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@mobility = 'M'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-negation" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@lemma = (normalize-unicode('μή'), normalize-unicode('μηδέ'), normalize-unicode('μήτε'), normalize-unicode('οὐ'), normalize-unicode('οὐδέ'), normalize-unicode('οὔτε'), normalize-unicode('οὐκ'), normalize-unicode('οὐχ'))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-neuter" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-gender($word) = 'n'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-nominative" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-case($word) = 'n'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-noun" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'n'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-numeral" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'm'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-ordinal-numeral" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'm' and ends-with($word/@lemma, 'ος')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:get-pos($word) = 'm' and ends-with($word/@lemma, 'ός')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-object" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="contains($word/@relation, 'OBJ')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-participle" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-mood($word) = 'p'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-particle" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <!-- List of particles taken from Bonifazi, Anna, Annemieke Drummen, and Mark de Kreij. 2016. Particles in Ancient Greek Discourse;
           ἄν is not on that list, but is described as a modal particle in Milev 1957, so I'm keeping it here for now. QAZ -->
      <xsl:when test="$word/@lemma = (normalize-unicode('ἄν'), normalize-unicode('ἄρα'), normalize-unicode('ἀτάρ'), normalize-unicode('γάρ'), normalize-unicode('γε'),
                      normalize-unicode('δέ'), normalize-unicode('δή'), normalize-unicode('δῆθεν'), normalize-unicode('δήπου'), normalize-unicode('δῆτα'),
                      normalize-unicode('ἦ'), normalize-unicode('ἤδη'), normalize-unicode('καίτοι'), normalize-unicode('μέν'), normalize-unicode('μέντοι'),
                      normalize-unicode('μήν'), normalize-unicode('οὖν'), normalize-unicode('που'), normalize-unicode('τε'), normalize-unicode('τοι'),
                      normalize-unicode('τοίγαρ'), normalize-unicode('τοίνυν')) and tb:get-pos($word) = 'd'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="$word/@lemma = (normalize-unicode('καί'), normalize-unicode('ἀλλά')) and tb:get-pos($word) = 'd'
                      and $word/@relation = ('AuxY', 'AuxY_CO', 'AuxZ', 'AuxZ_CO')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-name" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <!-- Zero or more non-letter characters followed by an uppercase letter at the start of the string. -->
      <xsl:when test="matches($word/@lemma, '^[\P{L}]*\p{Lu}')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Also works for placenames, e.g. Πτολεμαΐς τῆς Θηβαίδος -->
  <xsl:function name="tb:is-patronym" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:is-name($word) and tb:is-name($word/..) and tb:is-genitive($word) and tb:is-singular($word)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-plural" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-number($word) = 'p'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-preposition" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'r'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-pronoun" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'p'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-quantifier" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@lemma = $quantifiers">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-interrogative" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@lemma = $interrogatives">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-demonstrative-adjective" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@lemma = $demonstrative-adjectives">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-real-token" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="not(tb:is-artificial($word) or tb:is-gap($word) or tb:is-punctuation($word))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-singular" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-number($word) = 's'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-punctuation" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'u'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-subject" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-relation($word) = ('SBJ', 'SBJ_CO')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-subordinate-clause-head" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:variable name="attributive-participle" select="tb:is-attributive-participle($word)" as="xs:boolean"/>        
    <xsl:choose>
      <xsl:when test="tb:is-verb($word) 
        and not($word/@relation=('PRED', 'PRED_CO', 'ExD', 'ExD_CO')) 
        and not($attributive-participle)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:is-subordinating-conjunction" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@relation = ('AuxC', 'AuxC_CO')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-substantive" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = ('n', 'p')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:is-participle($word) and $word/word[tb:is-article(.)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:is-adjective($word) and $word/word[tb:is-article(.)] and $word/parent::word[not(tb:is-noun(.))]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:is-adverb($word) and $word/word[tb:is-article(.)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:is-numeral($word) and $word/word[tb:is-article(.)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-verb" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:get-pos($word) = 'v'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:display-percentage" as="xs:string">
    <xsl:param name="numerator"/>
    <xsl:param name="denominator"/>
    <xsl:choose>
      <xsl:when test="$denominator != 0">
        <xsl:value-of select="format-number($numerator div $denominator, '0.###%')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number(0, '0.##%')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:display-percentage-or-default" as="xs:string">
    <xsl:param name="numerator"/>
    <xsl:param name="denominator"/>
    <xsl:param name="default"/>
    <xsl:variable name="percentage" select="tb:display-percentage($numerator, $denominator)"/>
    <xsl:choose>
      <xsl:when test="$percentage = '0%'">
        <xsl:value-of select="$default"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$percentage"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:display-percentage-and-count" as="xs:string">
    <xsl:param name="numerator"/>
    <xsl:param name="denominator"/>
    <xsl:param name="default"/>
    <xsl:variable name="percentage" select="tb:display-percentage($numerator, $denominator)"/>
    <xsl:choose>
      <xsl:when test="$percentage = '0%'">
        <xsl:value-of select="$default"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($percentage, ' (', $numerator, ')')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:display-text-date" as="xs:string">
    <xsl:param name="element"/>
    <xsl:value-of select="$element/ancestor-or-self::treebank/metadata/date/century_display"/>
  </xsl:function>

  <xsl:function name="tb:is-diphthong" as="xs:boolean">
    <xsl:param name="letters"/>
    <xsl:choose>
      <xsl:when test="$letters = $diphthongs">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-vowel" as="xs:boolean">
    <xsl:param name="letter"/>
    <xsl:choose>
      <xsl:when test="$letter = $vowels">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:range" as="xs:integer*">
    <xsl:param name="start" as="xs:integer"/>
    <xsl:param name="end" as="xs:integer"/>
    <xsl:call-template name="get-range-recursive">
      <xsl:with-param name="start" select="$start"/>
      <xsl:with-param name="end" select="$end"/>
    </xsl:call-template>
  </xsl:function>
  
  <!-- This function returns true if the subtree headed
    by $subtree-head is interrupted by $word (i.e. there are
    ids both greater and lesser than the id of $word in the
    subtree) -->
  <xsl:function name="tb:subtree-is-discontinued-by-word" as="xs:boolean">
    <xsl:param name="subtree-head"/>
    <xsl:param name="word"/>
    <xsl:variable name="subtree-ids" select="$subtree-head/descendant-or-self::word/@id"/>
    <xsl:variable name="subtree-min">
      <xsl:value-of select="min($subtree-ids)"/>
    </xsl:variable>
    <xsl:variable name="subtree-max">
      <xsl:value-of select="max($subtree-ids)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$word/@id &gt; $subtree-min and $word/@id &lt; $subtree-max">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Return true if $head and $dependent have no words between them except articles. -->
  <xsl:function name="tb:words-are-continguous" as="xs:boolean">
    <xsl:param name="head"/>
    <xsl:param name="dependent"/>
    <xsl:variable name="head-id" select="xs:integer($head/@id)"/>
    <xsl:variable name="dependent-id" select="xs:integer($dependent/@id)"/>
    <xsl:variable name="contains-other" as="xs:string*">
      <xsl:for-each select="$head/ancestor::sentence[1]//word">
        <xsl:variable name="current-id" select="xs:integer(@id)"/>
        <xsl:if test="not(tb:is-article(.)) and (($current-id &gt; $head-id and $current-id &lt; $dependent-id)
            or ($current-id &gt; $dependent-id and $current-id &lt; $head-id))">
          <xsl:text>other</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="empty($contains-other)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:template name="corpus-selection">
    <section class="uk-section" id="corpus-selection">
      <h2>Corpus selection</h2>

      <xsl:variable name="selected" select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/int[normalize-space(@selected)]"/>
      <xsl:if test="$selected">
        <ul>
          <xsl:apply-templates mode="corpus-selection-selected" select="$selected"/>
        </ul>
      </xsl:if>

      <div class="uk-flex uk-flex-between">
        <div>
          <h3>Source corpus</h3>
          <table class="uk-table uk-table-striped">
            <tbody>
              <xsl:apply-templates mode="corpus-selection" select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='text_corpus']/int"/>
            </tbody>
          </table>

          <h3>Century</h3>
          <table class="uk-table uk-table-striped">
            <tbody>
              <xsl:apply-templates mode="corpus-selection" select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='text_century']/int">
                <xsl:sort select="@sort-date"/>
              </xsl:apply-templates>
            </tbody>
          </table>
          
          <h3>Proficiency</h3>
          <table class="uk-table uk-table-striped">
            <tbody>
              <xsl:apply-templates mode="corpus-selection" select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='text_language_proficiency']/int"/>
            </tbody>
          </table>

          <h3>Genre</h3>
          <table class="uk-table uk-table-striped">
            <tbody>
              <xsl:apply-templates mode="corpus-selection" select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='text_genre']/int"/>
            </tbody>
          </table>
        </div>
        <div>
          <h3>Author</h3>
          <table class="uk-table uk-table-striped">
            <tbody>
              <xsl:apply-templates mode="corpus-selection" select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='text_author']/int"/>
            </tbody>
          </table>
        </div>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="int" mode="corpus-selection">
    <!-- This relies on there being a global variable/parameter $corpus which is the current corpus definition string -->
    <xsl:variable name="new-corpus">
      <xsl:choose>
        <xsl:when test="normalize-space(@selected)">
          <xsl:value-of select="replace($corpus, concat('\', @selected, @name), '')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$corpus" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td><xsl:value-of select="@name"/></td>
      <td><xsl:value-of select="."/></td>
      <td>
        <xsl:choose>
          <xsl:when test="@selected = '+'">
            <xsl:text>+</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{kiln:url-for-match('display-corpus', (concat($new-corpus, '+', @name)), 0)}">
              <xsl:text>+</xsl:text>
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>/</xsl:text>
        <xsl:choose>
          <xsl:when test="@selected = '-'">
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="{kiln:url-for-match('display-corpus', (concat($new-corpus, '-', @name)), 0)}">
              <xsl:text>-</xsl:text>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:if test="normalize-space(@selected)">
          <xsl:variable name="url">
            <xsl:apply-templates mode="corpus-selection-selected-url" select="." />
          </xsl:variable>
          <a href="{$url}" class="delete has-background-danger" title="Remove this element from the corpus">Remove this element from the corpus</a>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="int" mode="corpus-selection-selected">
    <li class="is-inline mr-4">
      <xsl:variable name="url">
        <xsl:apply-templates mode="corpus-selection-selected-url" select="." />
      </xsl:variable>
      <xsl:value-of select="@selected"/><xsl:value-of select="@name"/>&#160;<a href="{$url}" title="Remove this element from the corpus"><span class="delete has-background-danger">Remove this element from the corpus</span></a>
    </li>
  </xsl:template>

  <xsl:template match="int" mode="corpus-selection-selected-url">
    <xsl:variable name="new-corpus" select="replace($corpus, concat('\', @selected, @name), '')"/>
    <xsl:choose>
      <xsl:when test="$new-corpus=''">
        <xsl:value-of select="kiln:url-for-match('local-home-page', (), 0)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="kiln:url-for-match('display-corpus', ($new-corpus), 0)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-range-recursive">
    <xsl:param name="start" as="xs:integer"/>
    <xsl:param name="end" as="xs:integer"/>
    <xsl:if test="$start &lt;= $end">
      <xsl:sequence select="$start"/>
      <xsl:call-template name="get-range-recursive">
        <xsl:with-param name="start" select="$start + 1"/>
        <xsl:with-param name="end" select="$end"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

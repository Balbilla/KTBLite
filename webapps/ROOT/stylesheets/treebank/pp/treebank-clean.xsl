<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet:
    - supplies the empty meta_text_type elements with content;
    - gets rid of other empty sematia child elements; 
    - normalizes unicode characters;
    - articles with any label other than ATR or with descendants are changed to pronouns in morphology
    - changes the morph annotation of particles acting as coordinators to particles;
    - changes the morph annotation of numerals WRONGLY annotated as adjectives to NUMERALS;
    - changes the morph annotation of possessive pronouns marked as adjectives to pronouns;
    - validates each sentence for whether it has the same number of words as in pre-transformation. 
    - For leuven files, moves the text_type inside hand_meta
    - Leuven: adds @artificial='elliptic' to artificial tokens
    - Leuven: transforms postag b into d
  -->
  
  <xsl:include href="../utils.xsl"/>

  <xsl:strip-space elements="*" />
    
  <xsl:template match="sematia/meta_text_type[not(normalize-space())]" priority="100">
    <xsl:copy>
      <xsl:text>None</xsl:text>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sematia/*[not(normalize-space())]"/>
  
  <xsl:template match="sentence">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="@word-count != count(.//word)">
        <xsl:attribute name="BORKED" select="true()"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>     
      <xsl:if test="contains(@form, 'gap')">
        <xsl:attribute name="is-gap" select="true()"/>
      </xsl:if>
      <!-- Fillers -->
      <xsl:if test="contains(@form, 'filler')">
        <xsl:attribute name="is-gap" select="true()"/>
      </xsl:if>
      <!-- Unintelligible -->
      <xsl:if test="contains(@form, 'unintelligible')">
        <xsl:attribute name="is-gap" select="true()"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[matches(@form, ',')]/@postag">
    <xsl:attribute name="postag" select="'u--------'"/>
  </xsl:template>
  
  <xsl:template match="word[@form='-']/@postag">
    <xsl:attribute name="postag" select="'u--------'"/>
  </xsl:template>
    
  <!-- Particles -->
  <xsl:template match="word[@postag='g--------']/@postag">
    <xsl:attribute name="postag">
      <xsl:text>d--------</xsl:text>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Leuven b postag particles -->
  <xsl:template match="word[@postag='b--------']/@postag">
    <xsl:attribute name="postag">
      <xsl:text>d--------</xsl:text>
    </xsl:attribute>
  </xsl:template>
  
  <!-- We'd be losing out on information if things that are already relationally marked as coordinated 
  are also morphologically changed to be conjunctions if they are particles. -->
  <xsl:template match="word[@lemma = (normalize-unicode('δέ'), normalize-unicode('τε'))
    and @relation = ('COORD', 'COORD_CO', 'AuxY', 'AuxY_CO', 'AuxZ', 'AuxZ_CO') and tb:is-conjunction(.)]/@postag" priority="10">
    <xsl:attribute name="postag">
      <xsl:text>d--------</xsl:text>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Conjunctions -->
  <xsl:template match="word[@lemma = normalize-unicode('καί')
    and @relation = ('COORD', 'COORD_CO', 'AuxY', 'AuxY_CO')]/@postag"  priority="100">
    <xsl:attribute name="postag">
      <xsl:text>c--------</xsl:text>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="word[@lemma = normalize-unicode('ἀλλά')]/@postag"  priority="100">
    <xsl:attribute name="postag">
      <xsl:choose>
        <xsl:when test="../@relation = ('COORD', 'COORD_CO')">
          <xsl:text>c--------</xsl:text>          
        </xsl:when>
        <xsl:when test="../@relation = ('AuxY', 'AuxY_CO', 'AuxZ', 'AuxZ_CO')">
          <xsl:text>d--------</xsl:text>          
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>      
  </xsl:template>
  
  <!-- Articles with any label other than ATR or with descendants are changed to pronouns in morphology -->
  <xsl:template match="word[tb:is-article(.)][not(@relation = 'ATR') or descendant::word]/@postag">
    <xsl:attribute name="postag">
      <xsl:text>p</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Leuven artificials -->
  <xsl:template match="word[matches(@form, '^\[\d+\]$')]" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="artificial" select="'elliptic'"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Numerals -->
  <xsl:template match="word[not(starts-with(@postag, 'm'))]
    [@lemma=(normalize-unicode('εἷς'),
    normalize-unicode('δύο'),
    normalize-unicode('τρεῖς'),
    normalize-unicode('τέτταρες'),
    normalize-unicode('τέσσαρες'),
    normalize-unicode('πέντε'),
    normalize-unicode('ἕξ'),
    normalize-unicode('ἑπτά'),
    normalize-unicode('ὀκτώ'),
    normalize-unicode('ἐννέα'),
    normalize-unicode('δέκα'),
    normalize-unicode('ἕνδεκα'),
    normalize-unicode('δώδεκα'),
    normalize-unicode('δεκαδύο'),
    normalize-unicode('τρεισκαίδεκα'),
    normalize-unicode('δεκάτρια'),
    normalize-unicode('τεσσαρεσκαιδέκα'),
    normalize-unicode('πεντεκαίδεκα'),
    normalize-unicode('δεκαέξ'),
    normalize-unicode('δεκάεξ'),
    normalize-unicode('ἑκκαίδεκα'),
    normalize-unicode('ὀκτωκαίδεκα'),
    normalize-unicode('δεκαεννέα'),
    normalize-unicode('ἐννεακαίδεκα'),
    normalize-unicode('εἴκοσι'),
    normalize-unicode('εἰκοσιδύο'),
    normalize-unicode('εἰκοσιπέντε'),
    normalize-unicode('εἰκοσιεπτά'),
    normalize-unicode('τριάκοντα'),
    normalize-unicode('τριακονταδύο'),
    normalize-unicode('τετταράκοντα'),
    normalize-unicode('τεσσαράκοντα'),
    normalize-unicode('τεσσαρακονταέξ'),
    normalize-unicode('πεντήκοντα'),
    normalize-unicode('ἑξήκοντα'),
    normalize-unicode('ἑξηκονταέξ'),
    normalize-unicode('ἑξηκονταεπτά'),
    normalize-unicode('ἑβδομήκοντα'),
    normalize-unicode('ὀγδοήκοντα'),
    normalize-unicode('ἐνενήκοντα'),
    normalize-unicode('ἑκατόν'),
    normalize-unicode('ἑκατονείκοσι'),
    normalize-unicode('διακόσιοι'),
    normalize-unicode('τριακόσιοι'),
    normalize-unicode('τετρακόσιοι'),
    normalize-unicode('τεσσερακόσιοι'),
    normalize-unicode('πεντακόσιοι'),
    normalize-unicode('ἑξακόσιοι'),
    normalize-unicode('ἑπτακόσιοι'),
    normalize-unicode('ὀκτακόσιοι'),
    normalize-unicode('ἐννεακόσιοι'),
    normalize-unicode('ἐνακόσιοι'),
    normalize-unicode('χίλιοι'),
    normalize-unicode('δισχίλιοι'),
    normalize-unicode('τρισχίλιοι'),
    normalize-unicode('τετραχίλιοι'),
    normalize-unicode('τετρακισχίλιοι'),
    normalize-unicode('πεντακισχίλιοι'),
    normalize-unicode('ἑξακισχίλιοι'),
    normalize-unicode('ὀκτακισχίλιοι'),
    normalize-unicode('μύριοι'),
    normalize-unicode('δισμύριοι'),
    normalize-unicode('τρισμύριοι'),
    normalize-unicode('πρῶτος'),
    normalize-unicode('δεύτερος'),
    normalize-unicode('τρίτος'),
    normalize-unicode('τέταρτος'),
    normalize-unicode('πέμπτος'),
    normalize-unicode('ἕκτος'),
    normalize-unicode('ἕβδομος'),
    normalize-unicode('ὄγδοος'),
    normalize-unicode('ἔνατος'),
    normalize-unicode('δέκατος'),
    normalize-unicode('ἐπιδέκατος'),
    normalize-unicode('ἑνδέκατος'),
    normalize-unicode('δωδέκατος'),
    normalize-unicode('τρεισκαιδέκατος'),
    normalize-unicode('τεσσαρεσκαιδέκατος'),
    normalize-unicode('δεκατέσσαρος'),
    normalize-unicode('πεντεκαιδέκατος'),
    normalize-unicode('ἑκκαιδέκατος'),
    normalize-unicode('ἑπτακαιδέκατος'),
    normalize-unicode('ὀκτωκαιδέκατος'),
    normalize-unicode('δεκαεννέος'),
    normalize-unicode('ἐννεακαιδέκατος'),
    normalize-unicode('εἰκοστός'),
    normalize-unicode('τετρακαιεικοστός'),
    normalize-unicode('εἰκοσιεπτός'),
    normalize-unicode('τριακοστός'),
    normalize-unicode('τεσσαρακονταπέμπτος'),
    normalize-unicode('τετταρακοστός'),
    normalize-unicode('τεσσαρακοστός'),
    normalize-unicode('πεντηκοστός'),
    normalize-unicode('ἑξηκοστός'),
    normalize-unicode('ἑβδομηκοστός'),
    normalize-unicode('ὀγδοηκοστός'),
    normalize-unicode('ἐνενηκοστός'),
    normalize-unicode('ἑκατοστός'),
    normalize-unicode('διακοσιοστός'),
    normalize-unicode('τριακοσιοστός'),
    normalize-unicode('τετρακοσιοστός'),
    normalize-unicode('πεντακοσιοστός'),
    normalize-unicode('ἑξακόσιος'),
    normalize-unicode('χιλιοστός'),
    normalize-unicode('χίλιος'),
    normalize-unicode('δισχίλιος'),
    normalize-unicode('τετρακισχίλιος'),
    normalize-unicode('πεντακισκείλιος'),
    normalize-unicode('μυριοστός'))]
    /@postag">
    <xsl:attribute name="postag">
      <xsl:text>m</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Leuven numerals -->
  <xsl:template match="word[contains(@lemma, '#')]/@postag" priority="12">
    <xsl:attribute name="postag">
      <xsl:text>m</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="word[@is_number]/@postag" priority="20">
    <xsl:attribute name="postag">
      <xsl:text>m</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Pronouns -->
  <!-- List taken from the Cambridge grammar -->
  <xsl:template match="word[tb:is-adjective(.)]
    [@lemma = (
    normalize-unicode('ἀλλήλων'), 
    normalize-unicode('αὐτός'), 
    normalize-unicode('ἀμφότερος'), 
    normalize-unicode('ἄλλος'), 
    normalize-unicode('ἄμφω'), 
    normalize-unicode('ἑαυτοῦ'),
    normalize-unicode('ἕκαστος'),
    normalize-unicode('ἑκάτερος'),
    normalize-unicode('ἐκεῖνος'), 
    normalize-unicode('ἐμαυτοῦ'), 
    normalize-unicode('ἐμός'), 
    normalize-unicode('ἑαυτοῦ'), 
    normalize-unicode('ἕτερος'), 
    normalize-unicode('ἡμέτερος'), 
    normalize-unicode('μηδείς'),
    normalize-unicode('οἷος'), 
    normalize-unicode('οὐδείς'),
    normalize-unicode('οὗτος'), 
    normalize-unicode('ὅδε'), 
    normalize-unicode('ὅς'), 
    normalize-unicode('ὅδε'), 
    normalize-unicode('ὅσος'), 
    normalize-unicode('ὅστις'),
    normalize-unicode('ὁπότερος'), 
    normalize-unicode('ὁπόσος'), 
    normalize-unicode('ὁποῖος'), 
    normalize-unicode('πηλίκος'), 
    normalize-unicode('ποῖος'),
    normalize-unicode('πότερος'), 
    normalize-unicode('πόσος'), 
    normalize-unicode('ποσος'), 
    normalize-unicode('σός'), 
    normalize-unicode('σφεῖς'), 
    normalize-unicode('σφέτερος'),
    normalize-unicode('τις'), 
    normalize-unicode('τίς'), 
    normalize-unicode('τοῖος'), 
    normalize-unicode('τοιόσδε'), 
    normalize-unicode('τοιοῦτος'), 
    normalize-unicode('τόσος'), 
    normalize-unicode('τοσόσδε'), 
    normalize-unicode('τοσοῦτος'),
    normalize-unicode('ὑμέτερος'), 
    normalize-unicode('ὑμός')
    )]
    /@postag">
    <xsl:attribute name="postag">
      <xsl:text>p</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="word[tb:is-punctuation(.)]/@postag" priority="100">
    <xsl:copy-of select="."/>
  </xsl:template>
  
   <xsl:template match="word[not(@lemma=normalize-unicode('ὁ')) and string-length(@lemma) = 1 
    and not(contains(@form, 'gap')) and tb:is-adjective(.)]/@postag" priority="11">
    <xsl:attribute name="postag">
      <xsl:text>m</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="word[matches(lower-case(@lemma), '^[βγδζθκλμνξπρσςτφχψϡϙ]+$')]/@postag">
    <xsl:attribute name="postag">
      <xsl:text>m</xsl:text>
      <xsl:value-of select="substring(., 2)"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="treebank/hand_meta[1]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:copy-of select="../text_type"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="treebank/text_type"/>
  
  <xsl:template match="sentence/@word-count"/>  
  
  <xsl:template match="word/@hand_id"/>
  
  <xsl:template match="word/@is_number"/>
  
  <xsl:template match="word/@lang"/>
  
  <xsl:template match="word/@line_n"/>
  
  <xsl:template match="word/@tm_w_id"/>
  
  <xsl:template match="word/@tp_n"/>  
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates words for being Mobile, postpositives or prepositives, according to Dover. In addition, 
  unclear cases are marked as X and artificials as z. NB! ALDT doesn't differentiate between adverbs and
  particles, introduced a relation-based distinction, test if applicable everywhere! -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word">
    <xsl:copy>
      <xsl:attribute name="mobility">
        <xsl:choose>
          <xsl:when test="@lemma = (normalize-unicode('ἀλλά'), normalize-unicode('ἀτάρ'), normalize-unicode('ἀτάρ'), 
            normalize-unicode('αὐτάρ'), normalize-unicode('ἤ'), normalize-unicode('ἦ'), normalize-unicode('καί'), 
            normalize-unicode('οὐδέ'), normalize-unicode('μηδέ'), normalize-unicode('οὔτε'), 
            normalize-unicode('μήτε'), normalize-unicode('εἴτε'))">
            <xsl:text>p</xsl:text>
          </xsl:when>
          <!-- Dover: "The simple negative is not easy to classify. It has obvious p characteristics [...]. Since, however,
          it may constitute a complete utterance by itself, and since the types of clause in which it may appear last are numerous, I do not treat is as p"
          HOWEVER! For my purposes I don't care about it being able to constitute an utterance by itself, so I will treat is as a p. -->
            <xsl:when test="tb:is-negation(.)">
            <xsl:text>p</xsl:text>
          </xsl:when>
          <xsl:when test="@lemma = (normalize-unicode('εἰ'), normalize-unicode('ἐπεί'), normalize-unicode('ἵνα'))">
            <xsl:text>p</xsl:text>
          </xsl:when>
          <xsl:when test="@lemma = (normalize-unicode('ἄρα'), normalize-unicode('ῥα'), normalize-unicode('αὖ'), 
            normalize-unicode('γάρ'), normalize-unicode('γε'), normalize-unicode('δαί'), 
            normalize-unicode('δέ'), normalize-unicode('δῆτα'), normalize-unicode('θην'), 
            normalize-unicode('μέν'), normalize-unicode('μήν'), normalize-unicode('μάν'), 
            normalize-unicode('οὖν'), normalize-unicode('ὦν'), normalize-unicode('περ'), normalize-unicode('τε'))">
            <xsl:text>q</xsl:text>
          </xsl:when>
          <xsl:when test="@lemma = (normalize-unicode('νυν'), normalize-unicode('νῦν'))">
            <xsl:text>q</xsl:text>
          </xsl:when>
          <xsl:when test="@lemma = normalize-unicode('τοι')">
            <xsl:text>q</xsl:text>
          </xsl:when>
          <xsl:when test="@lemma = normalize-unicode('δή')">
            <xsl:text>q</xsl:text>
          </xsl:when>     
          <xsl:when test="@lemma = (normalize-unicode('οἱ'), normalize-unicode('σφι')) and tb:is-pronoun(.)">
            <xsl:text>q</xsl:text>
          </xsl:when>
          <!-- Dover p. 13, II, ii - no semantic annotation so I need to decide on a case by case basis -->
          <xsl:when test="@lemma = normalize-unicode('μή')">
            <xsl:text>X</xsl:text>
          </xsl:when>
          <!-- MORE Semantics -->
          <xsl:when test="tb:is-pronoun(.)">
            <xsl:text>X</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-article(.)">
            <xsl:text>p</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-preposition(.)">
            <xsl:text>p</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-particle(.)">
            <xsl:text>q</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-adjective(.)">
            <xsl:text>M</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-adverb(.)">
            <xsl:text>M</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-numeral(.)">
            <xsl:text>M</xsl:text>
          </xsl:when>          
          <xsl:when test="tb:is-substantive(.)">
            <xsl:text>M</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-verb(.)">
            <xsl:text>M</xsl:text>
          </xsl:when>
          <xsl:when test="tb:is-artificial(.)">
            <xsl:text>z</xsl:text>
          </xsl:when>
          <!-- QAZ Check if actually true!!! -->
          <xsl:when test="@lemma = normalize-unicode('ἄν')">
            <xsl:text>q</xsl:text>
          </xsl:when>       
          <xsl:when test="tb:is-punctuation(.)">
            <xsl:text>n/a</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>X</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node()"/>      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

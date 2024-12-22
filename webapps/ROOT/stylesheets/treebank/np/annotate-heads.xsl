<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet is part of the process of annotating words with
       information regarding their participation in noun phrases.

       With regards to membership in a noun phrase, each word has one
       of four possible states, as set out below. The aim of this
       classification is to allow for analysis of discontinuities; it
       serves no other purpose.

         * a member;

         * a "visitor": a word in close association with the noun
         phrase but not a true part of it, eg attributive clause
         members, appositional words, participial phrases, prepositional phrases; 
         All potential "visitors" in a sentence are annotated as such,
         without checking if they are actually inside an np-tree;
         we never go from a visitor to an np, we only check nps 
         for whether they have visitors in them. This annotation
         does not interfere with the queries for nps when not 
         applicable.
         QAZ: Complete list?

         * an intruder: a word not in close association with the noun
         phrase;

         * not present within the noun phrase.

       This stylesheet adds the following annotations to each word:

         * @np-head="true" if it is the head of a noun phrase;

         * @visitor-head="true" if it is the head of a visitor phrase;

       Note that there is no requirement, at this stage at least, that
       any of these "phrases" consist of anything more than the word
       marked as the head.

  -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="word">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="tb:is-np-head(.)">
        <xsl:attribute name="np-head" select="true()"/>
        <xsl:variable name="head" select="."/>
        <xsl:variable name="article-ids" as="xs:integer*">
          <xsl:for-each select=".//word[tb:is-article-to-word(., $head)]" >
            <xsl:value-of select="xs:integer(@id)"/>
          </xsl:for-each>
          <xsl:for-each select="./parent::word/word[tb:is-article-to-word(., $head)]" >
            <xsl:value-of select="xs:integer(@id)"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:attribute name="article-ids" select="$article-ids"/>
        <xsl:attribute name="is-ds">
          <xsl:choose>
            <xsl:when test="count($article-ids) &gt; 1">
              <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:when test="$article-ids[1] &gt; xs:integer(@id)">
              <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="false()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>      
      <xsl:if test="tb:is-visitor-head(.)">
        <xsl:attribute name="visitor-head" select="true()"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="tb:is-np-head" as="xs:boolean">
    <xsl:param name="source-word"/>
    <xsl:choose>
      <xsl:when test="$source-word[tb:is-substantive(.)]/word[not(tb:is-punctuation(.) 
                      and @relation != 'COORD') and
                      not(tb:is-interjection(.)) and
                      not(tb:is-emphasizer(.))]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-visitor-head" as="xs:boolean">
    <xsl:param name="source-word"/>
    <xsl:choose>
      <!-- Attributive clause -->
      <xsl:when test="$source-word[tb:is-verb(.) and
                      not(tb:is-participle(.)) and
                      @relation = ('ATR', 'ATR_CO')]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Participial phrase (not a single attributive participle; those are treated as 'members'.) -->
      <xsl:when test="$source-word[tb:is-participle(.) and word[not(tb:is-punctuation(.) 
        and @relation != 'COORD') and
        not(tb:is-interjection(.)) and
        not(tb:is-emphasizer(.))]]">
        <xsl:value-of select="true()"/>        
      </xsl:when>
      <!-- Appositive phrases -->
      <!-- Because of deprecated annotation styles in perseids and gorman, do not mark APOS that contains _AP stuff -->
      <xsl:when test="$source-word[@relation=('APOS', 'APOS_CO') and not(word/@relation=('ATR_AP', 'ATR_AP_CO'))]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <!-- Prepositional phrases -->
      <xsl:when test="$source-word[tb:is-preposition(.)]">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>

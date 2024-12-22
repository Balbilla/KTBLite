<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- Returns the supplied inventory with all items removed except
       those that are found in the supplied text, annotated with
       counts of occurrences before and after the governing
       substantive. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="aggregation">
    <xsl:apply-templates select="inventory"/>
  </xsl:template>

  <xsl:template match="inventory">
    <xsl:variable name="words" select="/aggregation/treebank/sentences/sentence//word[tb:is-adjective(.)][@relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')]"/>
    <xsl:variable name="lemmata" select="distinct-values($words/@lemma)" as="xs:string*"/>
    <xsl:copy>
      <xsl:attribute name="number-of-sentences" select="../treebank/sentences/@n"/>
      <xsl:apply-templates select="item[@lemma = $lemmata]">
        <xsl:with-param name="words" select="$words"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="item">
    <xsl:param name="words"/>
    <xsl:variable name="item-lemma" select="@lemma"/>
    <xsl:variable name="item-words" select="$words[@lemma = $item-lemma]"/>
    <xsl:variable name="before-substantive-words" as="node()*">
      <xsl:apply-templates select="$item-words">
        <xsl:with-param name="position" select="'before'"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="after-substantive-words" as="node()*">
      <xsl:sequence select="$item-words except $before-substantive-words" />
    </xsl:variable>
    <xsl:variable name="count-before" select="count($before-substantive-words)"/>
    <xsl:variable name="count-after" select="count($after-substantive-words)"/>
    <xsl:if test="$count-before > 0 or $count-after > 0">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:attribute name="count-before-substantive" select="$count-before"/>
        <xsl:attribute name="count-after-substantive" select="$count-after"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="word">
    <xsl:variable name="adjective-id" select="xs:integer(@id)"/>
    <xsl:variable name="substantive-id" select="xs:integer(ancestor::word[tb:is-substantive(.)][1]/@id)"/>
    <xsl:if test="$adjective-id &lt; $substantive-id">
      <xsl:sequence select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

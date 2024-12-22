<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:include href="utils.xsl"/>
  
  <xsl:template match="word[not(tb:is-punctuation(.))]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="syllables">
        <xsl:call-template name="count-syllables">
          <xsl:with-param name="word" select="@form"/>
          <xsl:with-param name="position" select="1"/>
          <xsl:with-param name="current-count" select="0"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="count-syllables">
    <xsl:param name="current-count"/>
    <xsl:param name="position"/>
    <xsl:param name="word"/>
    <xsl:variable name="count">
      <xsl:choose>
        <xsl:when test="tb:is-vowel(substring($word, $position, 1)) and not(tb:is-diphthong(substring($word, $position - 1, 2)))">
          <xsl:value-of select="$current-count + 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$current-count"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="new-count">
      <xsl:choose>
        <xsl:when test="$position &lt; string-length($word)">
          <xsl:call-template name="count-syllables">
            <xsl:with-param name="current-count" select="$count"/>
            <xsl:with-param name="position" select="$position + 1"/>
            <xsl:with-param name="word" select="$word"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$count"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$new-count"/>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
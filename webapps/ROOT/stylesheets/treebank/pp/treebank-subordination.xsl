<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="sentence">
    <xsl:copy>
      <xsl:attribute name="subordination-count" select="count(descendant::word[tb:is-subordinate-clause-head(.)])"/>
      <xsl:attribute name="maximum-subordinate-clauses-depth">
        <xsl:variable name="sc_depths" as="xs:integer*">
          <xsl:sequence select="0"/>
          <xsl:for-each select="descendant::word[tb:is-subordinate-clause-head(.)]">
            <xsl:value-of select="count(ancestor::word[tb:is-subordinate-clause-head(.)]) + 1"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="max($sc_depths)"/>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

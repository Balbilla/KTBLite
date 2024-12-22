<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates the treebank element if it has any BORKED sentences. -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="treebank">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="sentences/sentence/@BORKED">
        <xsl:attribute name="BORKED" select="true()"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="matches(@form, '[A-Za-z]') and matches(@form, '[\p{IsGreek}\p{IsGreekExtended}]') 
        and not(contains(@form, 'num')) and not(tb:is-gap(.))">
        <xsl:attribute name="BORKED" select="true()"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

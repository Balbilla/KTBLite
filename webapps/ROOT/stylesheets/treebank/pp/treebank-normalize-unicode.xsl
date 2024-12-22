<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet normalizes the form and the lemma of greek words -->
  
  <xsl:include href="../utils.xsl"/>

  <xsl:template match="@form">
    <xsl:attribute name="form"><xsl:value-of select="normalize-unicode(.)"/></xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@lemma">
    <xsl:attribute name="lemma"><xsl:value-of select="normalize-unicode(.)"/></xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">  
  
  <!-- Because we may have added or removed sentences
    in the previous tranformations, we need to renumber 
    the sentences and add in the count of sentences. -->
 
  <xsl:include href="../utils.xsl"/>

  <xsl:template match="sentences">
    <xsl:copy>
      <xsl:attribute name="n" select="count(sentence)"/>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sentence">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="id" select="count(preceding::sentence) + 1"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

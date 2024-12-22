<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:include href="utils.xsl"/>
   
  <xsl:variable name="corpus" select="/aggregation/treebank/@corpus"/>
  <xsl:variable name="text" select="/aggregation/treebank/@text"/>
    
  <xsl:template match="sentences">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="token-count-all">
        <xsl:value-of select="count(.//word)"/>
      </xsl:attribute>
      <xsl:attribute name="token-count-actual">
        <xsl:value-of select="count(.//word[not(@relation=('AuxG', 'AuxK', 'AuxX'))])"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
 
</xsl:stylesheet>
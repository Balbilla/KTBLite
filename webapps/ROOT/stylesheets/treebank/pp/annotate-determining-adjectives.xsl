<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/" 
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:template match="item[not(@type)]">
    <xsl:copy>
      <xsl:if test="matches(@lemma, '^[\P{L}]*\p{Lu}')">
        <xsl:attribute name="type">
          <xsl:text>determining</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="ethnotoponym" select="true()"/>
      </xsl:if>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
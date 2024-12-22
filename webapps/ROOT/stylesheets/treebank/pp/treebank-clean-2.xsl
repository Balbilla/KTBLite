<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet finishes the cleaning procedure:
      - changes "_" into "-" in the @postag
      - deletes the brackets from @orig_form
  -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="@postag">
    <xsl:attribute name="postag">
      <xsl:value-of select="translate(., '_', '-')"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@orig_form">
    <xsl:attribute name="orig_form">
      <xsl:value-of select="translate(., '❨❩(){}&lt;&gt;∼∽⸢⸣', '')"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

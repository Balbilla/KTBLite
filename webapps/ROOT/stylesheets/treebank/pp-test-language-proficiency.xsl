<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:import href="utils.xsl"/>
  
  <xsl:template match="/">
    <xsl:variable name="pattern">
      <xsl:text>([αηωΑΗΩ</xsl:text>
      <xsl:value-of select="normalize-unicode('ὰ')"/>
      <xsl:value-of select="normalize-unicode('ά')"/>
      <xsl:value-of select="normalize-unicode('ᾶ')"/>
      <xsl:value-of select="normalize-unicode('ἀ')"/>
      <xsl:value-of select="normalize-unicode('ἂ')"/>
      <xsl:value-of select="normalize-unicode('ἄ')"/>
      <xsl:value-of select="normalize-unicode('ἆ')"/>
      <xsl:value-of select="normalize-unicode('ἁ')"/>
      <xsl:value-of select="normalize-unicode('ἃ')"/>
      <xsl:value-of select="normalize-unicode('ἅ')"/>
      <xsl:value-of select="normalize-unicode('ἇ')"/>
      <xsl:value-of select="normalize-unicode('ᾱ')"/>
      <xsl:value-of select="normalize-unicode('ᾰ')"/>
      <xsl:value-of select="normalize-unicode('Ὰ')"/>
      <xsl:value-of select="normalize-unicode('Ά')"/>
      <xsl:value-of select="normalize-unicode('Ἀ')"/>
      <xsl:value-of select="normalize-unicode('Ἂ')"/>
      <xsl:value-of select="normalize-unicode('Ἄ')"/>
      <xsl:value-of select="normalize-unicode('Ἆ')"/>
      <xsl:value-of select="normalize-unicode('Ἁ')"/>
      <xsl:value-of select="normalize-unicode('Ἃ')"/>
      <xsl:value-of select="normalize-unicode('Ἅ')"/>
      <xsl:value-of select="normalize-unicode('Ἇ')"/>
      <xsl:value-of select="normalize-unicode('Ᾱ')"/>
      <xsl:value-of select="normalize-unicode('Ᾰ')"/>      
      <xsl:value-of select="normalize-unicode('ὴ')"/>
      <xsl:value-of select="normalize-unicode('ή')"/>
      <xsl:value-of select="normalize-unicode('ἠ')"/>
      <xsl:value-of select="normalize-unicode('ἢ')"/>
      <xsl:value-of select="normalize-unicode('ἤ')"/>
      <xsl:value-of select="normalize-unicode('ἦ')"/>
      <xsl:value-of select="normalize-unicode('ῆ')"/>
      <xsl:value-of select="normalize-unicode('ἡ')"/>
      <xsl:value-of select="normalize-unicode('ἣ')"/>
      <xsl:value-of select="normalize-unicode('ἥ')"/>
      <xsl:value-of select="normalize-unicode('ἧ')"/>
      <xsl:value-of select="normalize-unicode('Ὴ')"/>
      <xsl:value-of select="normalize-unicode('Ή')"/>
      <xsl:value-of select="normalize-unicode('Ἠ')"/>
      <xsl:value-of select="normalize-unicode('Ἢ')"/>
      <xsl:value-of select="normalize-unicode('Ἤ')"/>
      <xsl:value-of select="normalize-unicode('Ἦ')"/>
      <xsl:value-of select="normalize-unicode('Ἡ')"/>
      <xsl:value-of select="normalize-unicode('Ἣ')"/>
      <xsl:value-of select="normalize-unicode('Ἥ')"/>
      <xsl:value-of select="normalize-unicode('Ἧ')"/>
      <xsl:value-of select="normalize-unicode('ὼ')"/>
      <xsl:value-of select="normalize-unicode('ώ')"/>
      <xsl:value-of select="normalize-unicode('ῶ')"/>
      <xsl:value-of select="normalize-unicode('ὠ')"/>
      <xsl:value-of select="normalize-unicode('ὢ')"/>
      <xsl:value-of select="normalize-unicode('ὤ')"/>
      <xsl:value-of select="normalize-unicode('ὦ')"/>
      <xsl:value-of select="normalize-unicode('ὡ')"/>
      <xsl:value-of select="normalize-unicode('ὣ')"/>
      <xsl:value-of select="normalize-unicode('ὥ')"/>
      <xsl:value-of select="normalize-unicode('ὧ')"/>
      <xsl:value-of select="normalize-unicode('Ὼ')"/>
      <xsl:value-of select="normalize-unicode('Ώ')"/>
      <xsl:value-of select="normalize-unicode('Ὠ')"/>
      <xsl:value-of select="normalize-unicode('Ὢ')"/>
      <xsl:value-of select="normalize-unicode('Ὤ')"/>
      <xsl:value-of select="normalize-unicode('Ὦ')"/>
      <xsl:value-of select="normalize-unicode('Ὡ')"/>
      <xsl:value-of select="normalize-unicode('Ὣ')"/>
      <xsl:value-of select="normalize-unicode('Ὥ')"/>
      <xsl:text>][ιι̣])|[</xsl:text>
      <xsl:value-of select="normalize-unicode('ᾳ')"/>
      <xsl:value-of select="normalize-unicode('ᾲ')"/>
      <xsl:value-of select="normalize-unicode('ᾴ')"/>
      <xsl:value-of select="normalize-unicode('ᾷ')"/>
      <xsl:value-of select="normalize-unicode('ᾀ')"/>
      <xsl:value-of select="normalize-unicode('ᾂ')"/>
      <xsl:value-of select="normalize-unicode('ᾄ')"/>
      <xsl:value-of select="normalize-unicode('ᾆ')"/>
      <xsl:value-of select="normalize-unicode('ᾁ')"/>
      <xsl:value-of select="normalize-unicode('ᾃ')"/>
      <xsl:value-of select="normalize-unicode('ᾅ')"/>
      <xsl:value-of select="normalize-unicode('ᾇ')"/>
      <xsl:value-of select="normalize-unicode('ῃ')"/>
      <xsl:value-of select="normalize-unicode('ῂ')"/>
      <xsl:value-of select="normalize-unicode('ῄ')"/>
      <xsl:value-of select="normalize-unicode('ῇ')"/>
      <xsl:value-of select="normalize-unicode('ᾐ')"/>
      <xsl:value-of select="normalize-unicode('ᾒ')"/>
      <xsl:value-of select="normalize-unicode('ᾔ')"/>
      <xsl:value-of select="normalize-unicode('ᾖ')"/>
      <xsl:value-of select="normalize-unicode('ᾑ')"/>
      <xsl:value-of select="normalize-unicode('ᾓ')"/>
      <xsl:value-of select="normalize-unicode('ᾕ')"/>
      <xsl:value-of select="normalize-unicode('ᾗ')"/>
      <xsl:value-of select="normalize-unicode('ῳ')"/>
      <xsl:value-of select="normalize-unicode('ῲ')"/>
      <xsl:value-of select="normalize-unicode('ῴ')"/>
      <xsl:value-of select="normalize-unicode('ῷ')"/>
      <xsl:value-of select="normalize-unicode('ᾠ')"/>
      <xsl:value-of select="normalize-unicode('ᾢ')"/>
      <xsl:value-of select="normalize-unicode('ᾦ')"/>
      <xsl:value-of select="normalize-unicode('ᾡ')"/>
      <xsl:value-of select="normalize-unicode('ᾣ')"/>
      <xsl:value-of select="normalize-unicode('ᾥ')"/>
      <xsl:value-of select="normalize-unicode('ᾧ')"/>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    <words>
      <xsl:for-each select="/aggregation/treebank/sentences/sentence//word[matches(@form, $pattern) and 
        not(matches(@orig_form, $pattern)) and normalize-space(@orig_form)]">
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <xsl:attribute name="sentence-id" select="ancestor::sentence/@id"/>
        </xsl:copy>        
      </xsl:for-each>
    </words>
  </xsl:template>
  
  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>
  
</xsl:stylesheet>

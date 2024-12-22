<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet assigns the correct @relation to the participants in a dating formula and
  gives the sentence a @is-dating-formula attribute. -->
  
  <xsl:include href="../utils.xsl"/>
    
  <xsl:template match="sentence[word[tb:is-artificial(.)]/word[@form=normalize-unicode('ἔτους')]]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="is-dating-formula" select="true()"/>
      <xsl:apply-templates select="node()" mode="dating-formula"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-artificial(.)]" mode="dating-formula">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="relation" select="'ExD'"/>
      <xsl:apply-templates select="node()" mode="dating-formula"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[@form= normalize-unicode('ἔτους')]" mode="dating-formula">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="relation" select="'ADV'"/>  
      <xsl:apply-templates select="node()" mode="dating-formula"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-name(.) and tb:is-artificial(parent::word) and @form!= normalize-unicode('Καίσαρος')]" mode="dating-formula">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="relation" select="'ADV'"/>
      <xsl:apply-templates select="node()" mode="dating-formula"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sentence/word[tb:is-artificial(.)]/word[@form=normalize-unicode('ἔτους')]/
    word[@form= normalize-unicode('Καίσαρος')]" mode="dating-formula">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="relation" select="'ATR'"/>
      <xsl:apply-templates select="node()" mode="dating-formula"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="@* | node() | comment()" mode="#default dating-formula">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

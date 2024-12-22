<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet moves the month from underneath Kaisaros to its rightful place under the artificial token.   -->
  
  <xsl:include href="../utils.xsl"/>
    
  <xsl:template match="word[tb:is-artificial(.) and parent::sentence][word[@form=normalize-unicode('ἔτους')]/
    word[@form=normalize-unicode('Καίσαρος')]/word[tb:is-name(.) and @relation='APOS']]">
    <xsl:variable name="month" select="word[@form=normalize-unicode('ἔτους')]/word[@form=normalize-unicode('Καίσαρος')]/word[tb:is-name(.) and @relation='APOS']"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>            
      <xsl:apply-templates select="word[xs:integer(@id) &lt; xs:integer($month/@id)]"/>
      <xsl:apply-templates select="$month" mode="dating-formula"/>
      <xsl:apply-templates select="word[xs:integer(@id) &gt; xs:integer($month/@id)]"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-artificial(.) and parent::sentence]/word[@form=normalize-unicode('ἔτους')]/
    word[@form=normalize-unicode('Καίσαρος')]/word[tb:is-name(.) and @relation='APOS']" mode="dating-formula">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>   
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-artificial(.) and parent::sentence]/word[@form=normalize-unicode('ἔτους')]/
    word[@form=normalize-unicode('Καίσαρος')]/word[tb:is-name(.) and @relation='APOS']"/>
    
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

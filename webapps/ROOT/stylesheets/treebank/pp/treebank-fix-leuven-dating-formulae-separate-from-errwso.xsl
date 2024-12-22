<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">  

<!-- First step of the processes dealing with the dating formulae problems in Leuven.
    This one deals with the cases in which the dating formula is clumped together with 
    ἔρρωσο by separating them into two sentences. -->
  
  <xsl:include href="../utils.xsl"/>

  <xsl:template match="sentence[word[@form=normalize-unicode('ἔρρωσο')] and .//word[@form=normalize-unicode('ἔτους')]]">
    <xsl:variable name="stop-id" select="xs:integer(.//word[@form=normalize-unicode('ἔτους')][1]/@id)"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="word" mode="truncate">
        <xsl:with-param name="stop-id" select="$stop-id"/>
      </xsl:apply-templates>
    </xsl:copy>
    <sentence id="{xs:integer(@id) + 1}">
      <word id="1" form="[0]" relation="ExD" artificial="elliptic" lemma="" postag="">
        <xsl:apply-templates select="word/word[xs:integer(@id) &gt;= $stop-id]"/>    
      </word>
    </sentence>
  </xsl:template>
    
  <xsl:template match="word" mode="truncate">
    <xsl:param name="stop-id"/>
    <xsl:if test="xs:integer(@id) &lt; $stop-id">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="word" mode="truncate">
          <xsl:with-param name="stop-id" select="$stop-id"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

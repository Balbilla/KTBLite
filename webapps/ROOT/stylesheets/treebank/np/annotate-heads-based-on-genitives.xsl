<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                exclude-result-prefixes="xs"
                version="2.0">
    
  <xsl:include href="../utils.xsl"/>
  
  <xsl:variable name="additions-argumental-governing" select="(normalize-unicode('κατασκευή'), 
    normalize-unicode('πάθος'), normalize-unicode('φορά'), normalize-unicode('σωτηρία'))"/>
  <xsl:variable name="additions-partitive-governing" select="normalize-unicode('μέρος')"/>
  
  <xsl:template match="word[normalize-space(@ag-modifiers)]">
    <xsl:copy>
      <xsl:attribute name="can-govern-genitive-category">
        <xsl:choose>
          <xsl:when test="@animacy='group' or @lemma=$additions-partitive-governing">
            <xsl:text>partitive</xsl:text>
          </xsl:when>
          <xsl:when test="@verbal-noun or @lemma=$additions-argumental-governing">
            <xsl:text>argumental</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>possessive</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

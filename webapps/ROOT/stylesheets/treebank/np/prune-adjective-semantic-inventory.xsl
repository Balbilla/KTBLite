<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- Returns the supplied inventory with all items removed except
       those that are found in the supplied text. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="inventory">
    <xsl:variable name="words" select="/aggregation/treebank/sentences/sentence//word[tb:is-adjective(.) and tb:is-attributive(.)]"/>
    <xsl:variable name="lemmata" select="distinct-values($words/@lemma)" as="xs:string*"/>
    <xsl:copy>
      <xsl:attribute name="number-of-sentences" select="../treebank/sentences/@n"/>
      <xsl:copy-of select="item[@lemma = $lemmata]"/>      
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

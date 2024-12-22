<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet annotates substantivized adjectives, nouns,
       pronouns and substantivized participles in the genitive marked
       with relation SBJ/SBJ_CO that are not marked as participating
       in a GA construction as rogue genitive agents . -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="word[tb:is-substantive(.) and tb:is-subject(.) and tb:is-genitive(.)]">
    <xsl:copy>
      <xsl:if test="not(@group)">
        <xsl:attribute name="rogue">true</xsl:attribute>
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

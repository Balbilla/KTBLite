<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:param name="corpus"/>

  <xsl:variable name="normalised-corpus">
    <xsl:if test="not(substring($corpus, 1) = ('+', '-'))">
      <xsl:text>+</xsl:text>
    </xsl:if>
    <xsl:value-of select="$corpus"/>
  </xsl:variable>

  <xsl:variable name="selected-facets" select="tokenize($normalised-corpus, '\+|\-')"/>

  <xsl:template match="lst[@name='facet_fields']/lst/int">
    <xsl:copy>
      <xsl:if test="@name=$selected-facets and @name != ''">
        <xsl:variable name="preceding" select="substring-before($normalised-corpus, @name)"/>
        <xsl:attribute name="selected">
          <xsl:value-of select="substring($preceding, string-length($preceding))" />
        </xsl:attribute>
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

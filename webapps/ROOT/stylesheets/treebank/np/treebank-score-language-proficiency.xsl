<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet generates an overall score and label for
  the level of proficiency. -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="language_proficiency">
    <xsl:variable name="score" select="sum(*/@score)"/>
    <xsl:copy>
      <xsl:attribute name="total-score" select="$score"/>
      <xsl:attribute name="label">
        <xsl:choose>
          <xsl:when test="$score &gt; 0">
            <xsl:text>nonstandard</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>standard</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

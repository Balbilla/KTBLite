<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- Annotate date facets for proper sorting. -->
  
  <xsl:template match="lst[@name='text_century']/int">
    <xsl:copy>
      <xsl:attribute name="sort-date">
        <xsl:choose>
          <xsl:when test="ends-with(@name, 'bc')">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="100 - xs:integer(substring-before(@name, 'bc'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before(@name, 'ad')"/>
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
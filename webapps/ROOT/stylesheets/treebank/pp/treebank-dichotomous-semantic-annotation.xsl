<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[normalize-space(@animacy) and tb:is-noun(.)]">
    <xsl:copy>
      <xsl:attribute name="semantic-type-animacy">
        <xsl:choose>
          <xsl:when test="@animacy = ('animal', 'group', 'person')">
            <xsl:text>animate</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>inanimate</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="semantic-type-person">
        <xsl:choose>
          <xsl:when test="@animacy = 'person'">
            <xsl:text>person</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>non-person</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="semantic-type-group">
        <xsl:choose>
          <xsl:when test="@animacy = 'group'">
            <xsl:text>group</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>non-group</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="semantic-type-concreteness">
        <xsl:choose>
          <xsl:when test="@animacy = 'concrete'">
            <xsl:text>concrete</xsl:text>
          </xsl:when>
          <xsl:when test="@animacy = 'nonconc'">
            <xsl:text>non-concrete</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>other</xsl:text>
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

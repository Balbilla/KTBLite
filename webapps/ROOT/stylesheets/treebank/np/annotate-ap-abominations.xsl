<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet gives attributes in
    noun phrases that have been annotated 
    with the deprecated annotation style 
    (ATR_AP and ATR_AP_CO governed by an APOS)
    a special attribute so that they are more easily 
    discoverable.
  -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="word[@np-head='true']">
    <xsl:copy>
      <xsl:variable name="id" select="concat(' ', @id, ' ')"/>
      <xsl:attribute name="deprecated-ap">
        <xsl:choose>
          <xsl:when test=".//word[contains(@np-heads, $id) and @relation=('ATR_AP', 'ATR_AP_CO')]">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
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

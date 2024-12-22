<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates adjectives which are separated from their noun by a Mobile
  as participating in a hyperbaton and annotates for edge- and gap-degree. -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[@governing-substantive]">
    <xsl:copy>
      <xsl:variable name="instigators" select="ancestor::sentence//word[tokenize(@instigating, '\s+') = current()/@id]"/>
      <xsl:attribute name="instigated-by">        
        <xsl:choose>
          <xsl:when test="$instigators[tb:is-mobile(.)]">
            <xsl:choose>
              <xsl:when test="$instigators[not(tb:is-mobile(.))]">
                <xsl:text>mixed</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>M</xsl:text>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:when>          
          <xsl:otherwise>
            <xsl:text>q</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="gap-degree">
        <xsl:value-of select="count($instigators)"/>
      </xsl:attribute>
      <xsl:attribute name="edge-degree">
        <!-- Counting how many instigating words that have no instigating ancestors 
          there are between the noun and the adjective, i.e. first level dependants of the np-head. -->
        <xsl:value-of select="count($instigators[not(tokenize(parent::word/@instigating, '\s+') = current()/@id)])"/>
      </xsl:attribute>      
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

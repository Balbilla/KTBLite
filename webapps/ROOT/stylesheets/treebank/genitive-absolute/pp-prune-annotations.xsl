<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet strips the @governs-* from any governing verb that is not the closest to the participle, uninterrupted by the coordinator. -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="@*[starts-with(name(), 'governs-')]">
    <xsl:variable name="coordinator-position" select="number(ancestor::word[tb:is-coordinator(.)][1]/@id)"/>
    <xsl:variable name="participle-position" select="number(.)"/>
    <xsl:variable name="verb-position" select="number(../@id)"/>
    <!-- When a coordinator is interrupting the verb and the participle, don't copy the attribute.-->
    <xsl:choose>
      <!-- Are there any other words governing this participle? -->
      <xsl:when test="count(ancestor::sentence//word[@id != current()/../@id]/@*[name() = current()/name()]) = 0">
        <xsl:copy/>
      </xsl:when>
      <xsl:when test="($verb-position &gt; $coordinator-position and $coordinator-position &gt; $participle-position) 
        or ($verb-position &lt; $coordinator-position and $coordinator-position &lt; $participle-position)"/>      
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

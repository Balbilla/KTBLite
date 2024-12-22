<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates each NP head with the contours of 
    preceding and following syllable lengths, 
    e.g. @preceding-*type-of-modifier*-syllable-contour="ascending" -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[@np-head='true']">
    <xsl:copy>  
      <xsl:if test="normalize-space(@multiple-adjectival-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'adjectival'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-demonstrative-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'demonstrative'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-nominal-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'nominal'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-numeral-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'numeral'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-participial-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'participial'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-pp-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'pp'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-pronominal-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'pronominal'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="normalize-space(@multiple-quantifier-modifiers)">
        <xsl:call-template name="syllable-contours">
          <xsl:with-param name="modifier-type" select="'quantifier'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="syllable-contours">
    <xsl:param name="modifier-type"/>
    <xsl:variable name="preceding-syllable-lengths" select="@*[local-name() = concat('preceding-', $modifier-type, '-syllable-lengths')]"/>
    <xsl:variable name="following-syllable-lengths" select="@*[local-name() = concat('following-', $modifier-type, '-syllable-lengths')]"/>
    <xsl:attribute name="{concat('preceding-', $modifier-type, '-syllable-contour')}">
      <xsl:choose>
        <xsl:when test="$preceding-syllable-lengths">
          <xsl:call-template name="determine-contour">
            <xsl:with-param name="syllable-counts" select="tokenize($preceding-syllable-lengths, '\s+')"/>
            <xsl:with-param name="current-contour" select="$syllable-contour-single"/>
            <xsl:with-param name="position" select="1"/>
          </xsl:call-template>            
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>none</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="{concat('following-', $modifier-type, '-syllable-contour')}">
      <xsl:choose>
        <xsl:when test="$following-syllable-lengths">            
          <xsl:call-template name="determine-contour">
            <xsl:with-param name="syllable-counts" select="tokenize($following-syllable-lengths, '\s+')"/>
            <xsl:with-param name="current-contour" select="$syllable-contour-single"/>
            <xsl:with-param name="position" select="1"/>
          </xsl:call-template>            
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>none</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>      
  </xsl:template>
  
  <xsl:template name="determine-contour">
    <xsl:param name="syllable-counts"/>
    <xsl:param name="current-contour"/>
    <xsl:param name="position"/>
    <xsl:choose>
      <xsl:when test="$position = count($syllable-counts)">
        <xsl:value-of select="$current-contour"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="current-syllable-count" select="$syllable-counts[$position]"/>
        <xsl:variable name="next-syllable-count" select="$syllable-counts[$position + 1]"/>
        <xsl:variable name="current-pair-contour">
          <xsl:choose>
            <xsl:when test="$current-syllable-count = $next-syllable-count">
              <xsl:value-of select="$syllable-contour-plateau"/><!-- this variable is defined in utils so that I can change the name if inspiration strikes at some point -->
            </xsl:when>
            <xsl:when test="$current-syllable-count &gt; $next-syllable-count">
              <xsl:value-of select="$syllable-contour-descending"/>
            </xsl:when>
            <xsl:when test="$current-syllable-count &lt; $next-syllable-count">
              <xsl:value-of select="$syllable-contour-ascending"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-contour">
          <xsl:choose>
            <xsl:when test="$current-contour = $syllable-contour-single">
              <xsl:value-of select="$current-pair-contour"/>
            </xsl:when>
            <xsl:when test="$current-contour = $current-pair-contour">
              <xsl:value-of select="$current-contour"/>
            </xsl:when>
            <xsl:when test="$current-contour = $syllable-contour-plateau">
              <xsl:value-of select="$current-pair-contour"/>
            </xsl:when>
            <xsl:when test="$current-pair-contour = $syllable-contour-plateau">
              <xsl:value-of select="$current-contour"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$syllable-contour-mixed"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$new-contour = $syllable-contour-mixed">
            <xsl:value-of select="$new-contour"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="determine-contour">
              <xsl:with-param name="syllable-counts" select="$syllable-counts"/>
              <xsl:with-param name="current-contour" select="$new-contour"/>
              <xsl:with-param name="position" select="$position + 1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <!-- This stylesheet annotates the distance between participants in Type 1 GA. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="construction[@type='1']">
    <xsl:copy>
      <xsl:call-template name="constituents-distance">
        <xsl:with-param name="agent-position" select="xs:integer(../../sentences/sentence[@id = current()/@sentence]//word[@is-agent = 'true' and @group = current()/@group]/@id)"/>
        <xsl:with-param name="participle-position" select="xs:integer(../../sentences/sentence[@id = current()/@sentence]//word[@is-participle = 'true' and @group = current()/@group]/@id)"/>
        <xsl:with-param name="sentence-id" select="@sentence"/>
      </xsl:call-template>
      <xsl:call-template name="constituents-distance-subtrees">
        <xsl:with-param name="group-id" select="@group"/>
        <xsl:with-param name="sentence-id" select="@sentence"/>
      </xsl:call-template>
      <xsl:apply-templates select="@* | node()"/>      
    </xsl:copy>
  </xsl:template>

  <xsl:template name="constituents-distance">
    <xsl:param name="agent-position"/>
    <xsl:param name="participle-position"/>
    <xsl:param name="sentence-id"/>
    <xsl:variable name="min-id">
      <xsl:choose>
        <xsl:when test="$agent-position &lt; $participle-position">
          <xsl:value-of select="$agent-position"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$participle-position"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="max-id">
      <xsl:choose>
        <xsl:when test="$agent-position &gt; $participle-position">
          <xsl:value-of select="$agent-position"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$participle-position"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name="constituents-distance">
      <xsl:value-of select="count(../../sentences/sentence[@id = $sentence-id]//word[xs:integer(@id) &gt; $min-id and xs:integer(@id) &lt; $max-id][not(tb:is-article(.))])"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template name="constituents-distance-subtrees">
    <xsl:param name="group-id"/>
    <xsl:param name="sentence-id"/>
    <xsl:attribute name="constituents-distance-subtree">
      <xsl:value-of select="count(../../sentences/sentence[@id = $sentence-id]//word[@*[name() = concat('intervenes-', $group-id)]][not(parent::word[@*[name() = concat('intervenes-', $group-id)]])])"/>
    </xsl:attribute>
  </xsl:template>
 
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

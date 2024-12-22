<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- Annotates each COORD as belonging to a genitive absolute construction group if and only if 
  it has 2 children participating in the same group. NB! A participating COORD may be one of the children! -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[tb:is-coordinator(.)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="child-participant-group-ids" as="xs:string*">
        <xsl:apply-templates select="*" mode="group"/>
      </xsl:variable>
      <xsl:if test="count($child-participant-group-ids) &gt; count(distinct-values($child-participant-group-ids))">
        <xsl:attribute name="group">
          <xsl:value-of select="$child-participant-group-ids[1]"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[@group]" mode="group">
    <xsl:sequence select="@group"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-coordinator(.)]" mode="group">
    <xsl:variable name="child-participant-group-ids" as="xs:string*">
      <xsl:apply-templates select="*" mode="group"/>
    </xsl:variable>
    <!-- This logic is predicated on the assumption that a COORD will never have 
    multiple children from more than one group. If this were the case, those children 
    would be made to belong to the same group in the previous step. We are assuming 
    that while a COORD may have multiple children each belonging to a different group,
    if there are multiple children in the same group, there are !!!NO!!! children belonging 
    to any other group. -->
    <xsl:if test="count($child-participant-group-ids) &gt; count(distinct-values($child-participant-group-ids))">
      <xsl:sequence select="$child-participant-group-ids[1]"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

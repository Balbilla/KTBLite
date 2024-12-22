<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <!-- This stylesheet annotates the words intervening between the constituents of a construction. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="sentence">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="sentence" select="."/>
      <xsl:variable name="group-ids" as="xs:string*" select="distinct-values(.//word/@group)"/>
      <xsl:variable name="maximum-group-ids" as="xs:integer*">
        <xsl:for-each select="$group-ids">
          <xsl:variable name="group-word-ids" as="xs:integer*">
            <xsl:for-each select="$sentence//word[@group = current()]">
              <xsl:sequence select="xs:integer(@id)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:sequence select="max($group-word-ids)"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="minimum-group-ids" as="xs:integer*">
        <xsl:for-each select="$group-ids">
          <xsl:variable name="group-word-ids" as="xs:integer*">
            <xsl:for-each select="$sentence//word[@group = current()]">
              <xsl:sequence select="xs:integer(@id)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:sequence select="min($group-word-ids)"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="group-ids" select="$group-ids"/>
        <xsl:with-param name="maximum-group-ids" select="$maximum-group-ids"/>
        <xsl:with-param name="minimum-group-ids" select="$minimum-group-ids"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:param name="group-ids"/>
    <xsl:param name="maximum-group-ids"/>
    <xsl:param name="minimum-group-ids"/>
    <xsl:variable name="word" select="."/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="$group-ids">
        <xsl:variable name="position" select="position()"/>
        <xsl:variable name="max-id" select="$maximum-group-ids[position() = $position]"/>
        <xsl:variable name="min-id" select="$minimum-group-ids[position() = $position]"/>
        <!-- The if-clause determines potential candidates for the @intervenes; the whens describe what the exceptions are. -->
        <xsl:if test="xs:integer($word/@id) &gt; $min-id and xs:integer($word/@id) &lt; $max-id">
          <xsl:choose>
            <xsl:when test="$word/@group = ."/>
            <xsl:when test="$word[tb:is-article(.)]/parent::word[@group = current()]"/>
            <!-- QAZ Should I be counting articles?? -->
            <xsl:when test="$word[tb:is-article(.)]"/>
            <!-- I'm not considering adjectives agreeing with the genitive agent or adjectives functioning as its PNOMs to be intervening -->
            <xsl:when test="$word[tb:is-adjective(.)][tb:agrees(., parent::word) or @relation = ('PNOM', 'PNOM_CO')]/parent::word[@group = current()]"/>
            <xsl:when test="$word[tb:is-punctuation(.)]"/>
            <xsl:otherwise>
              <xsl:attribute name="intervenes-{.}">
                <xsl:value-of select="true()"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:if>        
      </xsl:for-each>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="group-ids" select="$group-ids"/>
        <xsl:with-param name="maximum-group-ids" select="$maximum-group-ids"/>
        <xsl:with-param name="minimum-group-ids" select="$minimum-group-ids"/>  
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

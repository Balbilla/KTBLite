<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates all verbs governing genitive absolute constructions:
  Store the ids of any potential governed GA participles;
  Check whether the verb has any of those (by seeing if the string has content);
  Get the lowest id, i.e. the first participle, and have it be the value of the @governs. -->
  
  <xsl:include href="../utils.xsl"/>
    
  <xsl:template match="word[(tb:is-verb(.) or tb:is-artificial(.)) and not(@group)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="current-word" select="."/>      
      <xsl:for-each-group select="ancestor::sentence//word/@group" group-by=".">  
        <xsl:variable name="participle-ids" as="xs:integer*">
          <!-- We are assuming that the governing verb can be connected to the genitive participle upwards only through coordinators. -->
          <xsl:apply-templates select="$current-word/word | $current-word/parent::word[tb:is-coordinator(.)]" mode="path-to-participle">
            <xsl:with-param name="group-id" select="current-grouping-key()"/>
            <xsl:with-param name="source-word-id" select="$current-word/@id"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="count($participle-ids) &gt; 0">
          <!-- This for-each is needed in order to set the context for the id. -->
          <xsl:for-each select="$current-word">
            <xsl:call-template name="add-governs-attribute">            
            <xsl:with-param name="id" select="min($participle-ids)"/>
          </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each-group>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-coordinator(.)]" mode="path-to-participle">
    <xsl:param name="group-id"/>
    <xsl:param name="source-word-id"/>
    <xsl:apply-templates select="parent::word[@id!=$source-word-id and tb:is-coordinator(.)] | word[@id!=$source-word-id]" mode="path-to-participle">
      <xsl:with-param name="group-id" select="$group-id"/>
      <xsl:with-param name="source-word-id" select="@id"/>
    </xsl:apply-templates>     
  </xsl:template>
  
  <xsl:template match="word[tb:is-participle(.) and @group]" mode="path-to-participle">
    <xsl:param name="group-id"/>
    <xsl:if test="@group = $group-id">
      <!-- We'll be getting the minimum of those so they need to be integers. -->
      <xsl:sequence select="xs:integer(@id)"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="path-to-participle" />
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="add-governs-attribute">
    <xsl:param name="id"/>
    <xsl:attribute name="governs-{$id}">
      <xsl:value-of select="$id"/>
    </xsl:attribute>
  </xsl:template>
  
</xsl:stylesheet>

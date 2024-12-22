<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">
  
  <!-- This stylesheet combines all individual file inventories into a single inventory for ease of 
  use in the template. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:variable name="appearing-adjectives" select="/aggregation/xincludes/file/inventory/item"/>
  <xsl:variable name="qq-adjectives" select="$appearing-adjectives[@type='qq']"/>
  <xsl:variable name="determining-adjectives" select="$appearing-adjectives[@type='determining']"/>
  <xsl:variable name="uncategorized-adjectives" select="$appearing-adjectives[not(@type)]"/>
  <xsl:variable name="ethnotoponyms" select="$appearing-adjectives[@ethnotoponym='true']"/>

  <xsl:template match="xincludes">
    <inventory>
      <xsl:attribute name="number-of-sentences" select="sum(file/inventory/@number-of-sentences)"/>
      <xsl:for-each-group select="file/inventory/item" group-by="@lemma">
        <xsl:variable name="counts-before" as="xs:integer*">
          <xsl:for-each select="current-group()">
            <xsl:sequence select="xs:integer(@count-before-substantive)"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="total-counts-before" select="sum($counts-before)"/>
        <xsl:variable name="counts-after" as="xs:integer*">
          <xsl:for-each select="current-group()">
            <xsl:sequence select="xs:integer(@count-after-substantive)"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="total-counts-after" select="sum($counts-after)"/>
        <xsl:variable name="absolute-difference-in-counts" select="abs($total-counts-before - $total-counts-after)"/>
        <xsl:variable name="total-counts" select="sum(($total-counts-before, $total-counts-after))"/>
        <item lemma="{current-grouping-key()}" count-before-substantive="{$total-counts-before}" count-after-substantive="{$total-counts-after}"
        count-of-instances="{$total-counts}" absolute-difference-in-counts="{$absolute-difference-in-counts}">
          <xsl:variable name="instance" select="current-group()[1]"/>
          <xsl:if test="normalize-space($instance/@type)">
            <xsl:attribute name="type" select="$instance/@type"/>
          </xsl:if>
          <xsl:if test="normalize-space($instance/@ethnotoponym)">
            <xsl:attribute name="ethnotoponym" select="$instance/@ethnotoponym"/>
          </xsl:if>
        </item>
      </xsl:for-each-group>
    </inventory>    
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="../utils.xsl"/>

  <xsl:variable name="rogue" select="/aggregation/treebank/sentences/sentence//word[@rogue]"/>
  
  <xsl:template name="genitive-agents-summary">
    <xsl:text>Number of rogue agents in text - </xsl:text>
    <xsl:value-of select="count($rogue)"/>
  </xsl:template>
  
  <xsl:template name="genitive-agents-instances">
    <h2>Instances</h2>
    <ul>
      <xsl:for-each select="/aggregation/treebank/sentences/sentence[.//word/@rogue]">
        <li>
          <xsl:apply-templates select="."/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  <xsl:template match="sentence">
    <xsl:apply-templates select=".//word">
      <xsl:sort select="number(@id)"/>
    </xsl:apply-templates>
    <xsl:text> [</xsl:text>
    <a href="{kiln:url-for-match('sentence', (../../@corpus, ../../@text, @id), 0)}">
      <xsl:value-of select="@id"/>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:choose>
      <xsl:when test="@rogue">
        <strong><xsl:value-of select="@form"/></strong>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@form"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>
</xsl:stylesheet>

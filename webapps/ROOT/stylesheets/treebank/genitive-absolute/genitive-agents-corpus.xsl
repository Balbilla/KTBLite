<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="../utils.xsl"/>

  <xsl:variable name="corpus" select="/aggregation/xincludes/file[1]/treebank/@corpus"/>
  <xsl:variable name="rogue" select="/aggregation/xincludes/file/treebank/sentences/sentence//word[@rogue]"/>
  
  <xsl:template name="genitive-agents-summary">
    <xsl:text>Number of rogue agents in corpus - </xsl:text>    
    <xsl:value-of select="count($rogue)"/>
  </xsl:template>
  
  <xsl:template name="genitive-agents-instances">
   <h2>Instances</h2>
    <xsl:text>Constituents distance counts all intervening words (minus articles). At the moment this includes also adjectives that agree with the agent
    or are in a copula.</xsl:text>
      <ul>
        <xsl:for-each-group select="$rogue" group-by="ancestor::treebank/@text">
          <xsl:sort select="current-grouping-key()"/>
          <xsl:call-template name="display-text-link">
            <xsl:with-param name="count" select="count(current-group())"/>
            <xsl:with-param name="path" select="current-grouping-key()"/>
          </xsl:call-template>
        </xsl:for-each-group>
      </ul>    
  </xsl:template>
  
  <xsl:template name="display-text-link">
    <xsl:param name="count" />
    <xsl:param name="path" />
    <li>
      <a href="{kiln:url-for-match('genitive-agents-text', ($corpus, $path), 0)}"><xsl:value-of select="$path"/></a>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$count"/>
    </li>
  </xsl:template>
  
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                exclude-result-prefixes="xs"
                version="2.0">
  
  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>

  <xsl:template match="query">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xi:include>
        <xsl:attribute name="href">
          <xsl:value-of select="kiln:url-for-match('np-ag-position-summary-query', (), 1)"/>
          <xsl:text>?</xsl:text>          
          <xsl:variable name="parameters" as="xs:string*">
            <xsl:apply-templates select="@*" mode="query"/>
          </xsl:variable>
          <xsl:value-of select="string-join($parameters, '&amp;')"/>
          <xsl:text>&amp;rows=100000000&amp;w_is_proper_name=false&amp;w_has_article=true&amp;w_pos=Noun&amp;np_ag_pos=noun&amp;np_ag_is_name=false&amp;np_ag_position=internal</xsl:text>
        </xsl:attribute> 
      </xi:include>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@corpus" mode="query">
    <xsl:value-of select="concat('text_corpus=', .)"/>
  </xsl:template>
  
  <xsl:template match="@genre" mode="query">
    <xsl:value-of select="concat('text_genre=', .)"/>
  </xsl:template>
  
  <xsl:template match="@century" mode="query">
    <xsl:value-of select="concat('text_century=', .)"/>
  </xsl:template>
  
  <xsl:template match="@author" mode="query">
    <xsl:value-of select="concat('text_author=', .)"/>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

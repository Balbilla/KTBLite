<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs tb"
                version="2.0">
  
  <xsl:import href="../utils.xsl"/>

  <xsl:template match="treebank">
    <xsl:copy>
      <xsl:apply-templates select=".//word"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-artificial(.)]"/>
  
  <xsl:template match="word[tb:is-gap(.)]"/>
  
  <xsl:template match="@id"/>
  
  <xsl:template match="@mobility"/>
  
  <xsl:template match="@head"/>
  
  <xsl:template match="@relation"/>
  
  <xsl:template match="@BORKED"/>
  
  <xsl:template match="@hand"/>
  
  <xsl:template match="@pg_id"/>
  
  <xsl:template match="@tp_n"/>
  
  <xsl:template match="@line_n"/>
  
  <xsl:template match="@lang"/>
  
  <xsl:template match="@hand_id"/>
  
  <xsl:template match="@tm_w_id"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

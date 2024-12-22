<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0"
  xmlns:xi="http://www.w3.org/2001/XInclude">
  
  <!-- XSLT to generate a list of xinclude elements for each file in a solr results document. -->
  
  <!-- Prefix to be added to xinclude urls -->
  <xsl:param name="prefix"/>
  
  <xsl:template match="/">
    <xincludes>
      <xsl:apply-templates select="response/result/doc"/>
    </xincludes>
  </xsl:template>
  
  <xsl:template match="doc">
    <xsl:variable name="file-path" select="str[@name='file_path']"/>
    <file path="{$file-path}.xml">
      <xi:include href="{$prefix}{$file-path}.xml"/>
    </file>
  </xsl:template>
  
</xsl:stylesheet>
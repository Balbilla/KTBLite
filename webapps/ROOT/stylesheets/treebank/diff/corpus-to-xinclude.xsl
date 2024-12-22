<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xi="http://www.w3.org/2001/XInclude" 
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

 <xsl:template match="response">
   <aggregation>
     <xsl:apply-templates select="result/doc/str[@name='text_name']"/>     
   </aggregation>
 </xsl:template>
  
  <xsl:template match="str">
    <xi:include href="cocoon://treebank/diff/{.}.xml"/>
  </xsl:template>

</xsl:stylesheet>

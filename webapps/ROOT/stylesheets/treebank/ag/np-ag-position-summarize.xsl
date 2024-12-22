<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                exclude-result-prefixes="xs"
                version="2.0">

 <xsl:template match="response">
   <xsl:copy>
     <xsl:for-each-group select="result/doc" group-by="str[@name='w_lemma']">
       <xsl:sort select="current-grouping-key()"/>
       <xsl:variable name="lemma" select="current-grouping-key()"/>
       <xsl:for-each-group select="current-group()/arr[@name='np_ag_position']/str" group-by=".">
         <row lemma="{$lemma}" position="{current-grouping-key()}" count="{count(current-group())}" 
           ds-count="{count(current-group()[../../arr[@name='np_ag_is_ds']/bool = 'true'])}"/>
       </xsl:for-each-group>
     </xsl:for-each-group>
   </xsl:copy>
 </xsl:template>

</xsl:stylesheet>

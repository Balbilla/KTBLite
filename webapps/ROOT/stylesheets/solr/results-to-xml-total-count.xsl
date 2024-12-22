<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a Solr results document into a single count element
       giving details of the search and the total count of
       results. -->

  <xsl:template match="/">
    <count>
      <xsl:apply-templates select="response/lst[@name='responseHeader']/lst[@name='params']/arr[@name='fq']"/>
      <xsl:value-of select="response/result/@numFound"/>
    </count>
  </xsl:template>

  <xsl:template match="arr[@name='fq']">
    <xsl:for-each-group select="str" group-by="replace(substring-before(., ':'), '\{.*\}', '')">
      <xsl:attribute name="{current-grouping-key()}">
        <xsl:for-each select="current-group()">
          <xsl:value-of select="translate(substring-after(., ':'), '()&quot;', '')"/>
          <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>

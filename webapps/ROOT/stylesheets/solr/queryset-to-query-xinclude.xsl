<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a queryset document's query specification into
       an XInclude for the Solr query. -->

  <xsl:include href="cocoon://_internal/url/reverse.xsl"/>

  <xsl:template match="queryset">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <results>
        <xsl:variable name="query_file" select="normalize-space(query_file)"/>
        <xsl:variable name="base_query_parts" as="xs:string*">
          <xsl:text>?rows=1000000</xsl:text>
          <xsl:apply-templates mode="query" select="base/item"/>
        </xsl:variable>
        <xsl:variable name="querystring">
          <xsl:value-of select="string-join($base_query_parts, '&amp;')"/>
        </xsl:variable>
        <xi:include>
          <xsl:attribute name="href">
            <xsl:value-of select="kiln:url-for-match('local-search-query', ($query_file), 1)"/>
            <xsl:value-of select="$querystring"/>
          </xsl:attribute>
        </xi:include>
      </results>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

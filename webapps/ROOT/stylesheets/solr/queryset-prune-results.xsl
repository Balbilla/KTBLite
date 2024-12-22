<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

  <xsl:template match="queryset">
    <xsl:variable name="features" as="xs:string*">
      <xsl:apply-templates mode="list" select="groups/group/@name | columns/column/@name"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="features" select="$features" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="results/response/result/doc">
    <xsl:param name="features" tunnel="yes"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|*[@name = $features]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="results/response/lst[@name='facet_counts']/lst[@name='facet_fields']">
    <xsl:param name="features" tunnel="yes"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|*[@name = $features]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

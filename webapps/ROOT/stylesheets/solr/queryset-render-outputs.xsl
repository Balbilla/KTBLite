<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Render a queryset's tables according to the outputs specified,
       potentially adding and deleting tables. -->

  <xsl:template match="table">
    <xsl:if test="/queryset/outputs/output[@type='value']">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
    </xsl:if>
    <xsl:if test="/queryset/outputs/output[@type='percentage']">
      <xsl:variable name="decimal_places">
        <xsl:choose>
          <xsl:when test="/queryset/outputs/output[@type='percentage']/@decimal_places">
            <xsl:value-of select="/queryset/outputs/output[@type='percentage']/@decimal_places"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>all</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:copy>
        <xsl:attribute name="data-percentage-values" select="true()"/>
        <xsl:apply-templates mode="percentage" select="@* | node()">
          <xsl:with-param name="decimal_places" select="$decimal_places" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="caption" mode="percentage">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="."/>
      <xsl:text> (%)</xsl:text>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="td" mode="percentage">
    <xsl:param name="decimal_places" tunnel="yes"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="total" select="sum(../td)" as="xs:integer"/>
      <xsl:variable name="value" select="." as="xs:integer"/>
      <xsl:variable name="percentage" select="$value div $total * 100"/>
      <xsl:choose>
        <xsl:when test="$decimal_places = 'all'">
          <xsl:value-of select="$percentage"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="pattern">
            <xsl:text>0.</xsl:text>
            <xsl:for-each select="(1 to number($decimal_places))">
              <xsl:text>#</xsl:text>
            </xsl:for-each>
          </xsl:variable>
          <xsl:value-of select="format-number($percentage, $pattern)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" mode="#default percentage">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

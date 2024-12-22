<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <!-- This stylesheet annotates the AuxY conjunctions participating in polysyndeton as being part of the group of the last coord. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="word[tb:is-conjunction(.) and @relation='AuxY']">
    <xsl:copy>
      <xsl:if test="parent::word[tb:is-coordinator(.) and @group]">
        <xsl:attribute name="group">
          <xsl:value-of select="parent::word/@group"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

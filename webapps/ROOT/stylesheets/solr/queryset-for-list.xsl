<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="cocoon://_internal/url/reverse.xsl"/>

  <xsl:param name="filename"/>

  <xsl:template match="/">
    <item name="{$filename}"
              url="{kiln:url-for-match('queryset-results', ($filename), 0)}">
      <xsl:value-of select="queryset/title"/>
    </item>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="cocoon://_internal/url/reverse.xsl"/>

  <xsl:template match="/dir:directory">
    <items>
      <xsl:apply-templates select="dir:directory">
        <xsl:with-param name="path" select="''"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="dir:file">
        <xsl:with-param name="path" select="''"/>
      </xsl:apply-templates>
    </items>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="path"/>
    <xsl:variable name="new-path" select="concat($path, @name, '/')"/>
    <items name="{@name}">
      <xsl:apply-templates select="dir:directory">
        <xsl:with-param name="path" select="$new-path"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="dir:file">
        <xsl:with-param name="path" select="$new-path"/>
      </xsl:apply-templates>
    </items>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="path"/>
    <xsl:variable name="filename" select="substring-before(@name, '.xml')"/>
    <xsl:variable name="full-path" select="concat($path, $filename)"/>
    <xi:include href="{kiln:url-for-match('queryset-for-list', ($full-path), 1)}"/>
  </xsl:template>

</xsl:stylesheet>

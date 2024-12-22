<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dir="http://apache.org/cocoon/directory/2.0">

  <xsl:template match="/">
    <html>
      <head>
        <title>List of files in corpus for indexing.</title>
      </head>
      <body>
        <ul>
          <xsl:apply-templates select="/dir:directory/dir:file"/>
        </ul>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:variable name="directory" select="../@name"/>
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:text>/index/solr-add/</xsl:text>
          <xsl:value-of select="$directory"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$directory"/>
        <xsl:text>)</xsl:text>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>

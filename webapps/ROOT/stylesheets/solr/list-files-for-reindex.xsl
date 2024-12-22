<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>List of files in corpus for reindexing.</title>
      </head>
      <body>
        <ul>
          <xsl:apply-templates select="/response/result/doc"/>
        </ul>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="doc">
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:text>/index/solr-replace/</xsl:text>
          <xsl:value-of select="str[@name='file_path']"/>
          <xsl:text>.xml</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="str[@name='text_name']"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="str[@name='text_corpus']"/>
        <xsl:text>)</xsl:text>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0">  
  
  <xsl:import href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="dir:directory">
    <html>
      <head>
        <title>List of documents</title>
      </head>
      <body>
        <ul>
          <xsl:apply-templates select="dir:file"/>
        </ul>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="dir:file">
    <li>
      <a href="{kiln:url-for-match('preprocess-treebank-to-xml', (../@name, substring-before(@name, '.xml')), 0)}">
        <xsl:value-of select="@name"/>
      </a>
    </li>
  </xsl:template>
  
</xsl:stylesheet>

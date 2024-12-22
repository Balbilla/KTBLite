<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- Counts all tokens in the corpus and all tokens that are not punctuation -->
  
  <xsl:template match="/">
    <tokens>
      <all>
        <xsl:value-of select="count(treebank/sentences/sentence//word)"/>
      </all>
      <non-aux>
        <xsl:value-of select="count(treebank/sentences/sentence//word[not(@relation=('AuxG', 'AuxK', 'AuxX'))])"/>
      </non-aux>
    </tokens>    
  </xsl:template>
  
</xsl:stylesheet>
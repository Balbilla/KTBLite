<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:template match="/">
    <tokens>
      <all>
        <xsl:value-of select="sum(xincludes/file/tokens/all)"/>
      </all>
      <non-aux>
        <xsl:value-of select="sum(xincludes/file/tokens/non-aux)"/>
      </non-aux>
    </tokens>
  </xsl:template>
  
</xsl:stylesheet>
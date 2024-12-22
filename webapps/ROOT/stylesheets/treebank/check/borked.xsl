<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="treebank">
        <xsl:copy>
            <xsl:for-each select="sentences/sentence[@BORKED='true']">
                <borked><xsl:value-of select="@id"/></borked>
            </xsl:for-each>
        </xsl:copy>        
    </xsl:template>
    
</xsl:stylesheet>
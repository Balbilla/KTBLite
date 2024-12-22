<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="items">
        <xsl:copy>
            <xsl:for-each-group select="item" group-by ="@distribution">
                <xsl:for-each-group select="current-group()" group-by="@contour">
                    <item>                     
                        <xsl:copy-of select="@distribution"/>
                        <xsl:copy-of select="@contour"/>                  
                        <xsl:attribute name="count" select="count(current-group())"/>           
                    </item>                                    
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:copy>        
    </xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:param name="corpus"/>
    
    <xsl:template match="/">
        <inventory corpus="{$corpus}">
            <xsl:for-each-group select="xincludes/file/inventory/item" group-by="concat(@lemma, '+', @pos, '+', @relation)">
                <item>
                    <xsl:copy-of select="current-group()[1]/@lemma"/>
                    <xsl:copy-of select="current-group()[1]/@pos"/>
                    <xsl:copy-of select="current-group()[1]/@gender"/>
                    <xsl:copy-of select="current-group()[1]/@relation"/>
                    <xsl:attribute name="count" select="sum(current-group()/@count)"/>
                    <xsl:attribute name="text">
                        <xsl:for-each select="current-group()/@text">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>                        
                    </xsl:attribute>
                </item>
            </xsl:for-each-group>
        </inventory>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

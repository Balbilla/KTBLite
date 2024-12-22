<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:param name="corpus"/>
    
    <xsl:template match="/">
        <xsl:variable name="items" select="xincludes/file/inventory/item"/>
        <inventory corpus="{$corpus}">
            <xsl:for-each-group select="$items" group-by="concat(@lemma, '+', @pos)">
                <item>
                    <xsl:copy-of select="current-group()[1]/@lemma"/>
                    <xsl:copy-of select="current-group()[1]/@pos"/>
                    <xsl:copy-of select="current-group()[1]/@gender"/>
                    <xsl:attribute name="count" select="sum(current-group()/@count)"/>
                </item>
            </xsl:for-each-group>
        </inventory>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="@words">
        <xsl:attribute name="words">
            <xsl:value-of select="sum(../item/@count)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@lemmata">
        <xsl:attribute name="lemmata">
            <xsl:value-of select="count(../item)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
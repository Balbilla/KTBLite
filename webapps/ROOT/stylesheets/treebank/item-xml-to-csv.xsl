<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="items">
        <xsl:apply-templates select="item[1]" mode="headers"/>
        <xsl:apply-templates select="item"/>
    </xsl:template>
    
    <xsl:template match="item" mode="headers">
        <xsl:for-each select="@*">
            <xsl:value-of select="name()"/>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:for-each select="@*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>
</xsl:text>        
    </xsl:template>
    
</xsl:stylesheet>
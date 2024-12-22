<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for its modifiers -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@position-in-np]">
        <xsl:copy>
            <xsl:attribute name="bakker-category">
                <xsl:choose>
                    <xsl:when test="@position-in-np = ('preposed', 'postposed')">
                        <xsl:text>nonart</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>art</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for its numeral modifiers -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true' and normalize-space(@numeral-modifiers)]">
        <xsl:variable name="head" select="."/>
        <xsl:copy>
            <xsl:variable name="numeral-modifier-positions" as="xs:string*">
                <xsl:for-each select="tokenize(@numeral-modifiers, '\s+')">
                    <xsl:value-of select="tb:get-np-modifier-position($head, xs:integer(.))"/>
                </xsl:for-each>                
            </xsl:variable>
            <xsl:attribute name="numeral-modifier-positions" select="$numeral-modifier-positions"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

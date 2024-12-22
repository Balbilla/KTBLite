<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the numeral for its position in the NP -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[tb:is-numeral(.)]">
        <xsl:copy>
            <xsl:variable name="head" select="tb:get-governing-substantive(.)"/>
            <xsl:if test="@id = tokenize($head/@numeral-modifiers, '\s+')">
                <xsl:attribute name="position-in-np">
                    <xsl:value-of select="tb:get-np-modifier-position($head, @id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

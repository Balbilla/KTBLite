<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for its modifiers -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true' and normalize-space(@pp-modifiers)]">
        <xsl:variable name="head" select="."/>
        <xsl:variable name="pp-ids" select="tokenize($head/@pp-modifiers, '\s+')"/>
        <!--<xsl:variable name="adnominalPPlemma">
            <xsl:for-each select="descendant::word[@id = $pp-ids]">
                <xsl:sequence select="@lemma"/>                  
            </xsl:for-each>
        </xsl:variable>-->
        <xsl:copy>
            <xsl:attribute name="pp-modifier-preposition">
                <!--<xsl:for-each select="descendant::word[@id = $pp-ids]">
                    <xsl:sequence select="@lemma"/>
                </xsl:for-each>-->
                <xsl:for-each select="descendant::word[@id = $pp-ids]">
                    <xsl:sequence select="@lemma"/>                  
                </xsl:for-each>
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

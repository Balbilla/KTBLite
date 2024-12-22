<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for the lemma of its pronoun modifier -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true' and normalize-space(@pronominal-modifiers)]">
        <xsl:variable name="head" select="."/>
        <xsl:variable name="pronoun-ids" select="tokenize($head/@pronominal-modifiers, '\s+')"/>
        <xsl:copy>
            <xsl:attribute name="pronominal-modifier-lemma">
                <xsl:for-each select="descendant::word[@id = $pronoun-ids]">
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

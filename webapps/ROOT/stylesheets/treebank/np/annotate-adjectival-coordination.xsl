<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for the type of coordination of its adjectives -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true']"> 
        <xsl:variable name="np-head-id" select="@id"/>
        <xsl:variable name="adjectival-modifier-ids" select="tokenize(@adjectival-modifiers, '\s+')"/>
        <xsl:copy>
            <xsl:if test="@adjectival-modifiers">
                <xsl:variable name="adjectival-coordination">
                    <xsl:if test="word[@id = $adjectival-modifier-ids]">
                        <xsl:value-of select="$coordination-juxtaposed"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:if test=".//word[@id = $adjectival-modifier-ids][parent::word[tb:is-coordinator(.) and not(tb:is-punctuation(.))]]">
                        <xsl:value-of select="$coordination-coordinated"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:if test=".//word[@id = $adjectival-modifier-ids][parent::word[tb:is-coordinator(.) and tb:is-punctuation(.)]]">
                        <xsl:value-of select="$coordination-punctuation"/>
                        <xsl:text> </xsl:text>
                    </xsl:if> 
                    <xsl:if test=".//word[@id = $adjectival-modifier-ids][parent::word[not(@id = $np-head-id) and not(tb:is-coordinator(.))]]">
                        <xsl:value-of select="$coordination-other"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:variable>
                <xsl:attribute name="adjectival-coordination" select="normalize-space($adjectival-coordination)"/>
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

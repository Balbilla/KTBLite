<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:variable name="annotated-lemmata" select="/aggregation/inventory[1]/item/@lemma"/>
    
    <xsl:template match="aggregation">
        <xsl:apply-templates select="inventory[1]"/>
    </xsl:template>
    
    <xsl:template match="inventory[1]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="item"/>
            <xsl:apply-templates select="../inventory[2]/item"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="inventory[2]"/>
    
    <xsl:template match="item">
        <xsl:if test="not(@lemma = $annotated-lemmata)">
            <xsl:copy>
                <xsl:copy-of select="@lemma"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
        
</xsl:stylesheet>

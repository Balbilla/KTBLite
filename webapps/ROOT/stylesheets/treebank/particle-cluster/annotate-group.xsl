<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Annotates the cluster group with the id of the first participant and gets rid of the @cluster. -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@cluster='initial']">
        <xsl:copy>
            <xsl:attribute name="cluster-id" select="@id"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word[@cluster='not-initial']">
        <xsl:copy>
            <xsl:attribute name="cluster-id">
                <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) - 1]" mode="find-first-in-cluster"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word[tb:is-punctuation(.)]" mode="find-first-in-cluster">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) - 1]" mode="find-first-in-cluster"/>
    </xsl:template>
    
    <xsl:template match="word[@cluster='not-initial']" mode="find-first-in-cluster">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) - 1]" mode="find-first-in-cluster"/>
    </xsl:template>
    
    <xsl:template match="word[@cluster='initial']" mode="find-first-in-cluster">
        <xsl:value-of select="@id"/>
    </xsl:template>
       
    <xsl:template match="@cluster"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="treebank">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <constructions>
                <xsl:for-each select="sentences/sentence" >
                    <xsl:for-each-group select=".//word[@cluster-id]" group-by="@cluster-id">
                        <construction>
                            <xsl:attribute name="lemmata">
                                <xsl:for-each select="current-group()">
                                    <xsl:sort select="number(@id)"/>
                                    <xsl:value-of select="@lemma"/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:attribute>
                            <xsl:attribute name="sentence">
                                <xsl:value-of select="ancestor::sentence/@id"/>
                            </xsl:attribute>
                            <xsl:attribute name="cluster-id">
                                <xsl:value-of select="current-grouping-key()"/>
                            </xsl:attribute>
                            <xsl:attribute name="cluster-length">
                                <xsl:value-of select="count(current-group())"/>
                            </xsl:attribute>
                        </construction>
                    </xsl:for-each-group>
                </xsl:for-each>           
            </constructions>            
        </xsl:copy>        
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

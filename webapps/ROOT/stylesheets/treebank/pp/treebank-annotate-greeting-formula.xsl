<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
   
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="sentence[tb:is-artificial(word) and not(@is-dating-formula='true')]">
        <xsl:copy>
            <xsl:variable name="subjects" select=".//word[tb:is-subject(.) and tb:is-nominative(.)]"/>
            <xsl:variable name="datives" select=".//word[tb:is-object(.) and tb:is-dative(.)]"/>      
            <xsl:variable name="artificial" select="word[tb:is-artificial(.)]"/>
            <xsl:variable name="has-required-elements" as="xs:string*">
                <xsl:for-each select="$subjects">
                    <xsl:if test="tb:descends-directly-or-solely-via-coordinators(., $artificial)">
                        <xsl:sequence select="'a'"/>
                    </xsl:if>                    
                </xsl:for-each>
                <xsl:for-each select="$datives">
                    <xsl:if test="tb:descends-directly-or-solely-via-coordinators(., $artificial)">
                        <xsl:sequence select="'a'"/>
                    </xsl:if>                    
                </xsl:for-each>
            </xsl:variable>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="exists($has-required-elements)">
                <xsl:attribute name="is-greeting-formula" select="true()"/>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

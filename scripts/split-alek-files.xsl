<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/treebank">
        <xsl:for-each-group select="sentence" group-by="@filename">
            <xsl:sort order="ascending" select="@id"/>
            <xsl:call-template name="create-document">
                <xsl:with-param name="directory" select="'orig'"/>
                <xsl:with-param name="use-form" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="create-document">
                <xsl:with-param name="directory" select="'reg'"/>
                <xsl:with-param name="use-form" select="false()"/>
            </xsl:call-template>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="sentence">
        <xsl:param name="use-form"/>
        <xsl:copy>
            <xsl:copy-of select="@id"/>
            <xsl:apply-templates>
                <xsl:with-param name="use-form" select="$use-form"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="sentence" mode="metadata">
        <document_meta>            
            <xsl:apply-templates select="@period_max"/>
            <xsl:apply-templates select="@period_min"/>
            <xsl:apply-templates select="@place"/>
        </document_meta>
    </xsl:template>
    
    <xsl:template match="word">
        <xsl:param name="use-form"/>
        <xsl:copy>
            <xsl:copy-of select="@id"/>
            <xsl:choose>
                <xsl:when test="$use-form">
                    <xsl:copy-of select="@form"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="form" select="@regularized"/>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:copy-of select="@head"/>
            <xsl:copy-of select="@postag"/>
            <xsl:copy-of select="@relation"/>
            <xsl:copy-of select="@lemma"/>
            <xsl:copy-of select="@hand"/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template match="@period_max">
        <xsl:attribute name="date_not_after" select="xs:integer(.) * 100"/>
    </xsl:template>
    
    <xsl:template match="@period_min">
        <xsl:attribute name="date_not_before" select="xs:integer(.) * 100"/>
    </xsl:template>
    
    <xsl:template match="@place">
        <xsl:attribute name="place_name" select="."/>
    </xsl:template>
    
    <xsl:template match="@genre">
        <text_type>
            <xsl:attribute name="category">
                <xsl:choose>
                    <xsl:when test=". = 'receipt'">
                        <xsl:text>Receipt</xsl:text>
                    </xsl:when>
                    <xsl:when test=". = 'letter'">
                        <xsl:text>Letter</xsl:text>
                    </xsl:when>                    
                    <xsl:otherwise>
                        <xsl:text>FIX ME</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </text_type>        
    </xsl:template>
    
    <xsl:template name="create-document">
        <xsl:param name="directory"/>
        <xsl:param name="use-form"/>
        <xsl:result-document href="{concat($directory, '/', current-grouping-key(), '.xml')}" method="xml" indent="yes">
            <treebank>
                <xsl:apply-templates mode="metadata" select="current-group()[1]"/>
                <xsl:for-each-group select="current-group()/word/@hand" group-by=".">
                    <hand_meta>
                        <xsl:attribute name="id" select="position()"/><!-- hands are grouped by their values, so position gives me the count too-->
                        <xsl:attribute name="name" select="."/>
                    </hand_meta>
                </xsl:for-each-group>
                <xsl:for-each select="current-group()">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="use-form" select="$use-form"/>
                     </xsl:apply-templates>
                </xsl:for-each>
            </treebank>
        </xsl:result-document>
    </xsl:template>
    
    
    
</xsl:stylesheet>
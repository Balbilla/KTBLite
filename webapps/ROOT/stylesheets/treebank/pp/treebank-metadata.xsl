<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:variable name="administration-genres" select="('Administration', 'Account', 'Contract', 'Declaration', 'List', 'Memorandum', 'Memorandum (private)', 
        'Mixed', 'Notice', 'Notification', 'Offer', 'Order', 'Pronouncement', 'Receipt', 'Report')" as="xs:string"/>
    
    <xsl:template match="treebank">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="metadata"/>
                <xsl:when test="sematia">
                    <xsl:call-template name="metadata-sematia"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="metadata-papygreek"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="annotator"/>
    
    <xsl:template match="document_meta"/>
    
    <xsl:template match="hand_meta"/>
    
    <xsl:template match="meta_text_type">
        <xsl:choose>
            <xsl:when test="starts-with(., 'contract')">
                <xsl:text>Contract</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with(., 'letter')">
                <xsl:text>Letter</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with(., 'petition')">
                <xsl:text>Petition</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text_type">
        <xsl:if test="@category">
            <genre>
                <xsl:value-of select="@category"/>
            </genre>
            <xsl:if test="@category = $administration-genres">
                <genre>Administration</genre>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="sentences">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="token-count-all" select="count(sentence//word)"/>
            <xsl:attribute name="token-count-actual" select="count(sentence//word[tb:is-real-token(.)])"/>
            <xsl:attribute name="token-count-gap" select="count(sentence//word[tb:is-gap(.)])"/>
            <xsl:attribute name="token-count-punctuation" select="count(sentence//word[tb:is-punctuation(.)])"/>
            <xsl:attribute name="token-count-artificial" select="count(sentence//word[tb:is-artificial(.)])"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node() | comment()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node() | comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="metadata-sematia">
        <metadata>
            <date>
                <not_before><xsl:value-of select="sematia/document_date_not_before"/></not_before>
                <not_after><xsl:value-of select="sematia/document_date_not_after"/></not_after>
            </date>
            <place>
                <xsl:value-of select="sematia/document_provenience"/>
            </place>
            <genres>
                <genre>
                    <xsl:apply-templates select="sematia/meta_text_type"/>
                </genre>
            </genres>
        </metadata>
    </xsl:template>
       
    <xsl:template name="metadata-papygreek">
        <metadata>
            <date>
                <not_before><xsl:value-of select="document_meta/@date_not_before"/></not_before>
                <not_after><xsl:value-of select="document_meta/@date_not_after"/></not_after>
            </date>
            <place>
                <xsl:value-of select="document_meta/@place_name"/>
            </place>
            <genres>
                <xsl:for-each-group select="hand_meta/text_type" group-by="@category">
                    <!-- Potentially multiple hands within the same category, so I only want to apply templates to the first one -->
                    <xsl:apply-templates select="current-group()[1]"/>
                </xsl:for-each-group>
            </genres>
        </metadata>
    </xsl:template>
    
    <xsl:template match="sematia"/>
    
</xsl:stylesheet>

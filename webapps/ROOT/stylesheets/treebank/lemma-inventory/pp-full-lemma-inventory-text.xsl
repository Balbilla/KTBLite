<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:param name="corpus"/>
    <xsl:param name="text"/>
    
    <xsl:template match="/">
        <inventory corpus="{$corpus}" text="{$text}">
            <xsl:for-each-group select="treebank/sentences/sentence//word[not(tb:is-punctuation(.))][normalize-space(@lemma)]" group-by="concat(@lemma, '+', tb:get-pos(.), '+', @relation)">
                <xsl:variable name="word-in-group" select="current-group()[1]"/>
                <item>
                    <xsl:attribute name="lemma" select="$word-in-group/@lemma"/>
                    <xsl:attribute name="pos" select="tb:get-pos($word-in-group)"/>
                    <xsl:if test="tb:is-noun($word-in-group)">
                        <xsl:attribute name="gender" select="tb:get-gender($word-in-group)"/>
                    </xsl:if>
                    <xsl:attribute name="count" select="count(current-group())"/>
                    <xsl:attribute name="relation" select="$word-in-group/@relation"/>
                    <xsl:attribute name="text" select="$text"/>
                </item>
            </xsl:for-each-group>
        </inventory>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

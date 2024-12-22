<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="words" select="treebank/sentences/sentence//word[not(tb:is-punctuation(.))][normalize-space(@lemma)]"/>
        <inventory corpus="{treebank/@corpus}" text="{treebank/@text}" words="{count($words)}" lemmata="{count(distinct-values($words/@lemma))}">
            <xsl:for-each-group select="$words"  group-by="concat(@lemma, '+', tb:get-pos(.))">
                <xsl:variable name="word-in-group" select="current-group()[1]"/>
                <item>
                    <xsl:attribute name="lemma" select="substring-before(current-grouping-key(), '+')"/>
                    <xsl:attribute name="pos" select="substring-after(current-grouping-key(), '+')"/>
                    <xsl:if test="tb:is-noun($word-in-group)">
                        <xsl:attribute name="gender" select="tb:get-gender($word-in-group)"/>
                    </xsl:if>
                    <xsl:attribute name="count" select="count(current-group())"/>
                </item>
            </xsl:for-each-group>
        </inventory>
    </xsl:template>
    
</xsl:stylesheet>

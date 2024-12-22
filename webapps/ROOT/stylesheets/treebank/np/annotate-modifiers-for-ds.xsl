<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for its modifiers -->
    
    <xsl:import href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true' and @is-ds='true']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>            
            <xsl:apply-templates select="*">
                <xsl:with-param name="article-ids" select="tokenize(@article-ids, '\s+')"/>
                <xsl:with-param name="ag-modifiers" select="tokenize(@ag-modifiers, '\s+')"/>
                <xsl:with-param name="adj-modifiers" select="tokenize(@adjectival-modifiers, '\s+')"/>
                <xsl:with-param name="demonstrative-modifiers" select="tokenize(@demonstrative-modifiers, '\s+')"/>
                <xsl:with-param name="participial-modifiers" select="tokenize(@participial-modifiers, '\s+')"/>
                <xsl:with-param name="quantifier-modifiers" select="tokenize(@quantifier-modifiers, '\s+')"/>
                <xsl:with-param name="nominal-modifiers" select="tokenize(@nominal-modifiers, '\s+')"/>
                <xsl:with-param name="numeral-modifiers" select="tokenize(@numeral-modifiers, '\s+')"/>
                <xsl:with-param name="pp-modifiers" select="tokenize(@pp-modifiers, '\s+')"/>
                <xsl:with-param name="pronominal-modifiers" select="tokenize(@pronominal-modifiers, '\s+')"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word">
        <xsl:param name="article-ids" select="()"/>
        <xsl:param name="ag-modifiers" select="()"/>
        <xsl:param name="adj-modifiers" select="()"/>
        <xsl:param name="demonstrative-modifiers" select="()"/>
        <xsl:param name="participial-modifiers" select="()"/>
        <xsl:param name="quantifier-modifiers" select="()"/>
        <xsl:param name="nominal-modifiers" select="()"/>
        <xsl:param name="numeral-modifiers" select="()"/>
        <xsl:param name="pp-modifiers" select="()"/>
        <xsl:param name="pronominal-modifiers" select="()"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="current-modifiers">
                <xsl:choose>
                    <xsl:when test="@id = $ag-modifiers">
                        <xsl:value-of select="$ag-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $adj-modifiers">
                        <xsl:value-of select="$adj-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $demonstrative-modifiers">
                        <xsl:value-of select="$demonstrative-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $participial-modifiers">
                        <xsl:value-of select="$participial-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $quantifier-modifiers">
                        <xsl:value-of select="$quantifier-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $nominal-modifiers">
                        <xsl:value-of select="$nominal-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $numeral-modifiers">
                        <xsl:value-of select="$numeral-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $pp-modifiers">
                        <xsl:value-of select="$pp-modifiers"/>
                    </xsl:when>
                    <xsl:when test="@id = $pronominal-modifiers">
                        <xsl:value-of select="$pronominal-modifiers"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="count($current-modifiers) &gt; 0">
                <xsl:attribute name="ds-participant">
                    <xsl:variable name="current-id" select="xs:integer(@id)"/>
                    <xsl:apply-templates select="ancestor::sentence//word[@id = $current-id - 1]" mode="ds-participant">
                        <xsl:with-param name="article-ids" select="$article-ids"/>
                        <xsl:with-param name="current-modifiers" select="$current-modifiers"/>
                    </xsl:apply-templates>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="*">
                <xsl:with-param name="article-ids" select="$article-ids"/>
                <xsl:with-param name="ag-modifiers" select="$ag-modifiers"/>
                <xsl:with-param name="adj-modifiers" select="$adj-modifiers"/>
                <xsl:with-param name="demonstrative-modifiers" select="$demonstrative-modifiers"/>
                <xsl:with-param name="participial-modifiers" select="$participial-modifiers"/>
                <xsl:with-param name="quantifier-modifiers" select="$quantifier-modifiers"/>
                <xsl:with-param name="nominal-modifiers" select="$nominal-modifiers"/>
                <xsl:with-param name="numeral-modifiers" select="$numeral-modifiers"/>
                <xsl:with-param name="pp-modifiers" select="$pp-modifiers"/>
                <xsl:with-param name="pronominal-modifiers" select="$pronominal-modifiers"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word" mode="ds-participant">
        <xsl:param name="article-ids"/>
        <xsl:param name="current-modifiers"/>
        <xsl:choose>
            <xsl:when test="@id = $article-ids">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:when test="@id = 1">
                <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:when test="tb:is-coordinator(.) 
                or tb:is-particle(.) 
                or tb:is-punctuation(.)
                or @id = $current-modifiers">
                <xsl:variable name="current-id" select="xs:integer(@id)"/>
                <xsl:apply-templates select="ancestor::sentence//word[@id = $current-id - 1]" mode="ds-participant">
                    <xsl:with-param name="article-ids" select="$article-ids"/>
                    <xsl:with-param name="current-modifiers" select="$current-modifiers"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

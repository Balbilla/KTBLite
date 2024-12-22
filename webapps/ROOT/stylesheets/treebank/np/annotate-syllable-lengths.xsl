<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for 
        the number of syllables of its different types of modifiers:
        e.g.: @preceding-*modifier-type*-syllable-lengths="2 1", 
        when the earliest preceding modifier of the same type
        has two syllables and the next has one syllable.
    -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true']">
        <xsl:variable name="np-head" select="."/>
        <xsl:copy>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'adjectival'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'demonstrative'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'nominal'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'numeral'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'participial'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'pp'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'pronominal'"/>
            </xsl:call-template>
            <xsl:call-template name="syllable-length">
                <xsl:with-param name="np-head" select="$np-head"/>
                <xsl:with-param name="modifier-type" select="'quantifier'"/>
            </xsl:call-template>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="syllable-length">
        <xsl:param name="modifier-type"/>
        <xsl:param name="np-head"/>        
        <xsl:variable name="substantive-id" select="$np-head/@id"/>     
        <xsl:variable name="modifiers" as="node()*">
            <xsl:for-each select="tokenize(@*[local-name() = concat($modifier-type, '-modifiers')], '\s+')">
                <xsl:sequence select="$np-head//word[@id = current()]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="preceding-modifiers" select="$modifiers[xs:integer(@id) &lt; xs:integer($substantive-id)]"/>
        <xsl:variable name="following-modifiers" select="$modifiers[xs:integer(@id) &gt; xs:integer($substantive-id)]"/>
        <xsl:if test="count($modifiers) &gt; 1">
            <xsl:attribute name="{concat('multiple-', $modifier-type, '-modifiers')}" select="true()"/>
            <xsl:if test="$preceding-modifiers">
                <xsl:attribute name="{concat('preceding-', $modifier-type, '-syllable-lengths')}">
                    <xsl:for-each select="$preceding-modifiers">
                        <xsl:value-of select="@syllables"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$following-modifiers">
                <xsl:attribute name="{concat('following-', $modifier-type, '-syllable-lengths')}">
                    <xsl:for-each select="$following-modifiers">
                        <xsl:value-of select="@syllables"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

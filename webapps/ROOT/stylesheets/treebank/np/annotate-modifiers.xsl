<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for its modifiers -->
    
    <xsl:import href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true']">        
        <xsl:copy>
            <xsl:variable name="ag-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-ag-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$ag-modifiers">
                <xsl:attribute name="ag-modifiers" select="$ag-modifiers"/>
            </xsl:if>
            <xsl:variable name="adjectival-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-adjective-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$adjectival-modifiers">
                <xsl:attribute name="adjectival-modifiers" select="$adjectival-modifiers"/>
            </xsl:if>
            <xsl:variable name="demonstrative-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-demonstrative-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$demonstrative-modifiers">
                <xsl:attribute name="demonstrative-modifiers" select="$demonstrative-modifiers"/>
            </xsl:if>
            <xsl:variable name="participial-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-participial-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$participial-modifiers">
                <xsl:attribute name="participial-modifiers" select="$participial-modifiers"/>
            </xsl:if>
            <xsl:variable name="pp-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-pp-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$pp-modifiers">
                <xsl:attribute name="pp-modifiers" select="$pp-modifiers"/>
            </xsl:if>
            <xsl:variable name="quantifier-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-quantifier-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>                
            </xsl:variable>
            <xsl:if test="$quantifier-modifiers">
                <xsl:attribute name="quantifier-modifiers" select="$quantifier-modifiers"/>
            </xsl:if>
            <xsl:variable name="nominal-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-nominal-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>                
            </xsl:variable>
            <xsl:if test="$nominal-modifiers">
                <xsl:attribute name="nominal-modifiers" select="$nominal-modifiers"/>
            </xsl:if>
            <xsl:variable name="numeral-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-numeral-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>                
            </xsl:variable>
            <xsl:if test="$numeral-modifiers">
                <xsl:attribute name="numeral-modifiers" select="$numeral-modifiers"/>
            </xsl:if>
            <xsl:variable name="pronominal-modifiers" as="xs:int*">
                <xsl:apply-templates select=".//word" mode="find-pronominal-modifier">
                    <xsl:with-param name="np-head" select="."/>
                </xsl:apply-templates>                
            </xsl:variable>
            <xsl:if test="$pronominal-modifiers">
                <xsl:attribute name="pronominal-modifiers" select="$pronominal-modifiers"/>
            </xsl:if>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- NB! This only catches nouns that are not personal names -->
    <xsl:template match="word" mode="find-ag-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-genitive(.) and tb:is-noun(.) and not(tb:is-name(.))
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-adjective-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-adjective(.) and not(tb:is-quantifier(.)) and not(tb:is-demonstrative-adjective(.))
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')
            and tb:agrees(., tb:get-governing-substantive(.))">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-demonstrative-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-demonstrative-adjective(.)
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')
            and tb:agrees(., tb:get-governing-substantive(.))">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-nominal-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-noun(.) and not(tb:is-genitive(.))
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-numeral-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-numeral(.)
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-participial-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-participle(.) and not(tb:is-genitive(.))
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')
            and tb:agrees(., tb:get-governing-substantive(.))">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-pp-modifier">        
        <xsl:param name="np-head"/>
        <xsl:variable name="preposition" select="."/>
        <xsl:if test="tb:is-preposition(.)
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and .//word[@relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')][not(tb:is-verb(.))]
            [tb:descends-directly-or-solely-via-coordinators(., $preposition)]">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-pronominal-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-pronoun(.) and not(tb:is-genitive(.))
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')
            and tb:agrees(., tb:get-governing-substantive(.))">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="word" mode="find-quantifier-modifier">
        <xsl:param name="np-head"/>
        <xsl:if test="tb:is-quantifier(.)
            and tb:descends-directly-or-solely-via-coordinators(., $np-head)
            and @relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO')
            and tb:agrees(., tb:get-governing-substantive(.))">
            <xsl:sequence select="@id"/>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

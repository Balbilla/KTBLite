<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Here we are assuming that negation particles do not cluster with other particles 
    and so we exclude them from looking for clusters. -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:variable name="non-clustering-particles" as="xs:string*">
        <xsl:sequence select="(normalize-unicode('οὐ'), normalize-unicode('οὐκ'), normalize-unicode('οὐχ'), 
            normalize-unicode('μή'), normalize-unicode('μήτε'), normalize-unicode('οὐδέ'), normalize-unicode('οὔτε'))"/>
    </xsl:variable>
    
    <xsl:template match="word[tb:is-particle(.) and not(@lemma= $non-clustering-particles)]">
        <xsl:copy>
            
            <xsl:variable name="has-preceding-particle" as="xs:boolean">
                <!-- For when the particle is the first word of the sentence -->
                <xsl:choose>
                    <xsl:when test="@id = '1'">
                        <xsl:value-of select="false()"/>
                    </xsl:when>                            
                    <xsl:otherwise>
                        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) - 1]" mode="find-adjacent-particle">
                            <xsl:with-param name="step" select="-1"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="following-word" select="ancestor::sentence//word[number(@id) = number(current()/@id) + 1]"/>
            <xsl:variable name="has-following-particle" as="xs:boolean">
                <xsl:choose>
                    <xsl:when test="$following-word">
                        <xsl:apply-templates select="$following-word" mode="find-adjacent-particle">
                            <xsl:with-param name="step" select="1"/>
                        </xsl:apply-templates>                           
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$has-preceding-particle">
                    <xsl:attribute name="cluster" select="'not-initial'"/>
                </xsl:when>
                <xsl:when test="$has-following-particle">
                    <xsl:attribute name="cluster" select="'initial'"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word[tb:is-particle(.) and not(@lemma= $non-clustering-particles)]" mode="find-adjacent-particle">
        <xsl:value-of select="true()"/>
    </xsl:template>
    
    <!-- When we hit punctuation, we need to keep looking (forward or backwards), not crossing over the boundaries
        of the sentence. Hence, if the first or last word is a punctuation mark, we can stop looking; otherwise we go on
        to the next word. -->
    
    <xsl:template match="word[tb:is-punctuation(.)]" mode="find-adjacent-particle">
        <xsl:param name="step"/>
        <xsl:choose>
            <xsl:when test="$step = -1 and @id = 1">
                <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:when test="$step = 1 and not(ancestor::sentence//word[number(@id) = number(current()/@id) + 1])">
                <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="find-adjacent-particle">
                    <xsl:with-param name="step" select="$step"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!-- If we hit a word that is not a particle, we can stop looking -->
    
    <xsl:template match="word" mode="find-adjacent-particle">
        <xsl:value-of select="false()"/>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="modifier"/>
    
    <xsl:variable name="DS" select="'DS'"/>
    <xsl:variable name="DS-part" select="'DS-part'"/>
    <xsl:variable name="internal" select="'internal'"/>
    <xsl:variable name="postposed" select="'postposed'"/>
    <xsl:variable name="preposed" select="'preposed'"/>    
    
    <xsl:variable name="DS-preposed" select="'preposed'"/>
    <xsl:variable name="DS-postposed" select="'postposed'"/>
    
    <xsl:template match="/">
        <items>
            <xsl:apply-templates select="/response/result/doc"/>
        </items>      
    </xsl:template>
    
    <xsl:template match="doc">
        <!--- This template only checks if the modifier (or cluster of modifiers) falls into 
        the category; the annotation is done in the following template. -->        
        <xsl:variable name="pattern_elements" select="('2art', '1noun', '9art', $modifier)"/>
        <xsl:variable name="subpatterns" as="xs:string*">
            <xsl:for-each select="tokenize(str[@name='np_tree_pattern'], '\s+')">
                <xsl:if test=". = $pattern_elements">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>        
        <xsl:variable name="pattern" select="string-join($subpatterns, ' ')"/>
        <!--- Preposed -->
        <xsl:if test="starts-with($pattern, $modifier)">
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$preposed"/>
            </xsl:apply-templates>
        </xsl:if>
        <!--- Internal -->
        <xsl:if test="matches($pattern, concat('[29]art( ', $modifier, ')+ 1noun'))">
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$internal"/>
            </xsl:apply-templates>
        </xsl:if>
        <!-- Postposed -->
        <xsl:if test="matches($pattern, concat('1noun ', $modifier))">
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$postposed"/>
            </xsl:apply-templates>
        </xsl:if>
        <!-- DS preposed -->
        <xsl:if test="matches($pattern, concat('[29]art( ', $modifier, ')+ 2art 1noun'))">
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$DS-part"/>
                <xsl:with-param name="subcategory" select="$DS-preposed"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$DS"/>
            </xsl:apply-templates>
        </xsl:if>
        <!-- DS postposed -->
        <xsl:if test="matches($pattern, concat('1noun [29]art ', $modifier))">
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$DS-part"/>
                <xsl:with-param name="subcategory" select="$DS-postposed"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="create-item">
                <xsl:with-param name="category" select="$DS"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="doc" mode="create-item">
        <xsl:param name="category"/>
        <xsl:param name="subcategory"/>
        <item>
            <xsl:attribute name="category" select="$category"/>
            <!-- Only the earliest date is shown -->
            <xsl:attribute name="date" select="arr[@name='text_century']/str[1]"/>
            <xsl:attribute name="genre" select="arr[@name='text_genre']/str[1]"/>
            <xsl:attribute name="author" select="str[@name='text_author']"/>
            <xsl:attribute name="corpus" select="str[@name='text_corpus']"/>
            <xsl:attribute name="pattern" select="str[@name='np_articular_adjectival_subpattern']"/>
            <xsl:attribute name="subcategory" select="$subcategory"/>
        </item>
    </xsl:template>
    
</xsl:stylesheet>
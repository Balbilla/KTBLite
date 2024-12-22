<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the noun phrase
        with multiple modifiers for the position of the modifiers
        with relation to the head and for their heaviness in terms 
        of ther position in relation to one another. 
        
        NB! All np-heads will have @preceding- and @following-subtree-contour
        because of faceting.
    -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true']">
        <xsl:copy>            
                <xsl:variable name="is-complex">
                    <xsl:for-each select="tokenize(normalize-space(concat(@preceding-subtree-sizes, ' ', @following-subtree-sizes)), '\s+')"><!-- at least one space -->
                        <xsl:if test="xs:integer(.) &gt; 1">
                            <xsl:value-of select="true()"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
            <xsl:if test="boolean(normalize-space($is-complex))">
                <xsl:attribute name="has-complex-subtree" select="true()"/>
            </xsl:if>
            <xsl:attribute name="preceding-subtree-contour">                
                <xsl:choose>                    
                    <xsl:when test="@preceding-subtree-sizes">
                        <xsl:call-template name="determine-contour">
                            <xsl:with-param name="subtree-counts" select="tokenize(@preceding-subtree-sizes, '\s+')"/>
                            <xsl:with-param name="current-contour" select="$subtree-contour-single"/><!-- when there's only one modifier (the other one may be on the other side of the noun), we state this is a single by necessity -->
                            <xsl:with-param name="position" select="1"/>
                        </xsl:call-template>             
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>none</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>            
            <xsl:attribute name="following-subtree-contour">
                <xsl:choose>
                    <xsl:when test="@following-subtree-sizes">                        
                        <xsl:call-template name="determine-contour">
                            <xsl:with-param name="subtree-counts" select="tokenize(@following-subtree-sizes, '\s+')"/>
                            <xsl:with-param name="current-contour" select="$subtree-contour-single"/><!-- when there's only one modifier (the other one may be on the other side of the noun), we state this is a single by necessity -->
                            <xsl:with-param name="position" select="1"/>
                        </xsl:call-template>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>none</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:attribute>            
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="determine-contour">
        <xsl:param name="subtree-counts"/>
        <xsl:param name="current-contour"/>
        <xsl:param name="position"/>
        <xsl:choose>
            <xsl:when test="$position = count($subtree-counts)">
                <xsl:value-of select="$current-contour"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="current-subtree-count" select="$subtree-counts[$position]"/>
                <xsl:variable name="next-subtree-count" select="$subtree-counts[$position + 1]"/>
                <xsl:variable name="current-pair-contour">
                    <xsl:choose>
                        <xsl:when test="$current-subtree-count = $next-subtree-count">
                            <xsl:value-of select="$subtree-contour-plateau"/><!-- this variable is defined in utils so that I can change the name if inspiration strikes at some point -->
                        </xsl:when>
                        <xsl:when test="$current-subtree-count &gt; $next-subtree-count">
                            <xsl:value-of select="$subtree-contour-descending"/>
                        </xsl:when>
                        <xsl:when test="$current-subtree-count &lt; $next-subtree-count">
                            <xsl:value-of select="$subtree-contour-ascending"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="new-contour">
                    <xsl:choose>
                        <xsl:when test="$current-contour = $subtree-contour-single">
                            <xsl:value-of select="$current-pair-contour"/>
                        </xsl:when>
                        <xsl:when test="$current-contour = $current-pair-contour">
                            <xsl:value-of select="$current-contour"/>
                        </xsl:when>
                        <xsl:when test="$current-contour = $subtree-contour-plateau">
                            <xsl:value-of select="$current-pair-contour"/>
                        </xsl:when>
                        <xsl:when test="$current-pair-contour = $subtree-contour-plateau">
                            <xsl:value-of select="$current-contour"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$subtree-contour-mixed"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$new-contour = $subtree-contour-mixed">
                        <xsl:value-of select="$new-contour"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="determine-contour">
                            <xsl:with-param name="subtree-counts" select="$subtree-counts"/>
                            <xsl:with-param name="current-contour" select="$new-contour"/>
                            <xsl:with-param name="position" select="$position + 1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

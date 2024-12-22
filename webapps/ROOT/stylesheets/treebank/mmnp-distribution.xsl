<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">    
      
    <xsl:template match="/">
        <items>
            <xsl:apply-templates select="/response/result/doc"/>
        </items>      
    </xsl:template>
    
    <xsl:template match="doc">
        <xsl:variable name="distribution" select="str[@name = 'np_mmnp_distribution']"/>
         <item>
             <xsl:choose>
                 <xsl:when test="$distribution = 'only preceding'">
                     <xsl:attribute name="distribution" select="$distribution"/>
                     <xsl:attribute name="contour" select="str[@name = 'np_preceding_subtree_contour']"/>
                 </xsl:when>
                 <xsl:when test="$distribution = 'only following'">
                     <xsl:attribute name="distribution" select="$distribution"/>
                     <xsl:attribute name="contour" select="str[@name = 'np_following_subtree_contour']"/>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:attribute name="distribution" select="'both preceding'"/>
                     <xsl:attribute name="contour" select="str[@name = 'np_preceding_subtree_contour']"/>
                 </xsl:otherwise>
             </xsl:choose>
         </item>
        <xsl:if test="$distribution = 'both sides'">
            <item>
                <xsl:attribute name="distribution" select="'both following'"/>
                <xsl:attribute name="contour" select="str[@name = 'np_following_subtree_contour']"/>
            </item>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
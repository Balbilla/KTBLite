<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="grouping-category"/>
    <!-- The possible values of this parameter can be seen at [modifier]-p.xsl 
        among the attributes given to the item. --> 
    
    <xsl:template match="items">
        <xsl:copy>
            <xsl:for-each-group select="item" group-by="@*[name() = $grouping-category]">
                <xsl:for-each-group select="current-group()" group-by="@category">
                    <xsl:for-each-group select="current-group()" group-by="@subcategory">
                        <item>                        
                            <xsl:attribute name="count" select="count(current-group())"/>                        
                            <xsl:copy-of select="@category"/>
                            <xsl:copy-of select="@subcategory"/>
                            <xsl:copy-of select="@*[name() = $grouping-category]"/>
                        </item>                    
                    </xsl:for-each-group>
                </xsl:for-each-group>
            </xsl:for-each-group>
        </xsl:copy>        
    </xsl:template>
    
</xsl:stylesheet>
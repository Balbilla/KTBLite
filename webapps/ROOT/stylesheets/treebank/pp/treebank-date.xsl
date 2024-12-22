<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet is adding two additional elements to display date -
        one for the display of centuries so that the system doesn't have to go
        through figuring them out with the function in utils every time, and
        one that will be used wherever we need to sort or normalize things by 
        centuries where a single value is necessary. -->
    
    <xsl:include href="../utils.xsl"/>
        
    <xsl:template match="metadata/date">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:variable name="not_before_century" select="tb:date-to-century(not_before)"/>
            <xsl:variable name="not_after_century" select="tb:date-to-century(not_after)"/>
            
                <xsl:choose>    
                    <xsl:when test="not(normalize-space($not_before_century)) and not(normalize-space($not_after_century))">
                        <century_display>unknown</century_display>
                    </xsl:when>
                    <xsl:when test="not(normalize-space($not_before_century))">
                        <century_display><xsl:value-of select="$not_after_century"/></century_display>
                        <centuries n="{$not_after_century}"/>                        
                    </xsl:when>
                    <xsl:when test="not(normalize-space($not_after_century)) or $not_before_century = $not_after_century">
                        <century_display><xsl:value-of select="$not_before_century"/></century_display>
                        <centuries n="{$not_before_century}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <century_display><xsl:value-of select="concat($not_before_century, ' – ', $not_after_century)"/></century_display>
                        <centuries n="{tb:range(xs:integer($not_before_century), xs:integer($not_after_century))}"/>
                    </xsl:otherwise>
                </xsl:choose>    
            
            <century_processing>
                <xsl:choose>
                    <xsl:when test="normalize-space($not_before_century)">
                        <xsl:value-of select="$not_before_century"/>
                    </xsl:when>
                    <xsl:when test="normalize-space($not_after_century)">
                        <xsl:value-of select="$not_after_century"/>
                    </xsl:when>
                </xsl:choose>
            </century_processing>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@* | node() | comment()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node() | comment()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

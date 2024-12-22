<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="gender"/>
    <xsl:param name="lemma"/>
    <xsl:param name="pos"/>
    
    <xsl:template match="item">
        <xsl:choose>
            <xsl:when test="$gender != 'request-param:gender' and not($gender = @gender)"/>           
            <xsl:when test="$lemma != 'request-param:lemma' and not($lemma = @lemma)"/>
            <xsl:when test="$pos != 'request-param:pos' and not($pos = @pos)"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
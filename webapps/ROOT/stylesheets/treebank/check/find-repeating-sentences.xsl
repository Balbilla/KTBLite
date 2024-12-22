<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:key name="sentence-text" match="/treebank/sentence" use="string-join(.//word/@form, ' ')"></xsl:key>
    
    <xsl:template match="/">
        <duplicates>
            <xsl:for-each select="treebank/sentence">
                <xsl:variable name="text" select="string-join(.//word/@form, ' ')"/>
                <xsl:variable name="dups" select="key('sentence-text', $text)"/>
                <xsl:if test="count($dups) &gt; 1">
                    <p>
                        <xsl:for-each select="$dups">
                            <xsl:value-of select="@id"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </p>
                </xsl:if>
            </xsl:for-each>
        </duplicates>
    </xsl:template>
    
</xsl:stylesheet>
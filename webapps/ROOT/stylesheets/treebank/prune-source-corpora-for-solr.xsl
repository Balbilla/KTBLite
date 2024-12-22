<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:dir="http://apache.org/cocoon/directory/2.0"
    xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">  
    
    <!-- Removes test source corpora so that they are not indexed by solr -->
    
    <xsl:template match="dir:directory[starts-with(@name, 'test-')]"/>
    
    <xsl:template match="@* | node() | comment()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node() | comment()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
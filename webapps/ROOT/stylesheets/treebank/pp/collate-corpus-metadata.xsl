<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Assembles metadata from the individual texts in the corpus into 
    useful categories, e.g. total tokens, tokens per century, number of sentences 
    per century etc. -->
    
    <xsl:template match="xincludes">
        <xsl:variable name="root" select="."/>
        <corpus_metadata>
            <xsl:attribute name="token-count-actual" select="sum(file/treebank/sentences/@token-count-actual)"/>
            <xsl:attribute name="token-count-all" select="sum(file/treebank/sentences/@token-count-all)"/>
            <xsl:attribute name="sentences" select="sum(file/treebank/sentences/@n)"/>
            <centuries>
                <xsl:for-each select="distinct-values(file/treebank/metadata/date/century_processing)">
                    <xsl:variable name="century-treebanks" select="$root/file/treebank[metadata/date/century_processing = current()]"/>
                    <century n="{.}">
                        <xsl:attribute name="token-count-actual" select="sum($century-treebanks/sentences/@token-count-actual)"/>
                        <xsl:attribute name="token-count-all" select="sum($century-treebanks/sentences/@token-count-all)"/>
                        <xsl:attribute name="sentences" select="sum($century-treebanks/sentences/@n)"/>
                    </century>
                </xsl:for-each>
            </centuries>
        </corpus_metadata>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>  
    
</xsl:stylesheet>
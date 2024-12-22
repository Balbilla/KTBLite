<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
    <xsl:include href="../utils.xsl"/>

    <xsl:variable name="corpus" select="inventory/@corpus"/>
    
    <xsl:template name="full-inventory">
        <h2>Lemmata with different annotation</h2>
        <p>
            <xsl:text>This table contains lemmata that represent the same word but have been assigned different relation labels. This is needed in order to have a better
            definition of what the possible values for classes of words are. Its creation is prompted by the complete mess in the treatment of particles.</xsl:text>
        </p>       
        <table class="tablesorter">
            <thead>
                <th>Lemma</th>
                <th>Relation</th>
                <th>PoS</th>
                <th>Count</th>
                <th>Texts</th>
            </thead>
            <tbody>
                <xsl:for-each-group select="inventory/item" group-by="@lemma">
                    <xsl:if test="count(current-group()) &gt; 1">
                        <xsl:for-each select="current-group()">
                            <tr>
                                <td><xsl:value-of select="@lemma"/></td>
                                <td><xsl:value-of select="@relation"/></td>
                                <td><xsl:value-of select="@pos"/></td>
                                <td><xsl:value-of select="@count"/></td>
                                <td>
                                    <xsl:for-each select="tokenize(@text, ' ')">
                                        <a href="{kiln:url-for-match('display-text', ($corpus, .), 0)}"><xsl:value-of select="."/></a>
                                        <xsl:if test="position() != last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </td>
                            </tr>
                        </xsl:for-each>                        
                    </xsl:if>
                </xsl:for-each-group>
            </tbody>
        </table>
    </xsl:template>

    
</xsl:stylesheet>

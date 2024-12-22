<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
    <xsl:include href="../noun-phrase-common-display.xsl"/>
    <xsl:include href="../utils.xsl"/>
    
    <xsl:variable name="appearing-adjectives" select="/aggregation/inventory/item[xs:integer(@count-before-substantive) &gt; 0 or xs:integer(@count-after-substantive) &gt; 0]"/>
    <xsl:variable name="qq-adjectives" select="$appearing-adjectives[@type='qq']"/>
    <xsl:variable name="determining-adjectives" select="$appearing-adjectives[@type='determining']"/>
    <xsl:variable name="uncategorized-adjectives" select="$appearing-adjectives[not(@type)]"/>
    
    <xsl:template name="adjective-semantics-summary">
        <table class="tablesorter">
            <tr>
                <th>Number of sentences</th>
                <td>
                    <xsl:value-of select="/aggregation/inventory/@number-of-sentences"/>
                </td>
            </tr>
            <tr>
                <th scope="row">Number of uncategorized adjectives</th>
                <td><xsl:value-of select="count($uncategorized-adjectives)"/></td>
            </tr>
            <tr>
                <th>Presubstantive uncategorized</th>
                <td>
                    <xsl:value-of select="count($uncategorized-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/>
                </td>
            </tr>
            <tr>
                <th>Postsubstantive uncategorized</th>
                <td>
                    <xsl:value-of select="count($uncategorized-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/>
                </td>
            </tr>
            <tr>
                <th scope="row">Number of qq adjectives</th>
                <td>
                    <xsl:value-of select="count($qq-adjectives)"/>
                </td>
            </tr>
            <tr>
                <th>Presubstantive qq</th>
                <td>
                    <xsl:value-of select="count($qq-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/>
                </td>
            </tr>
            <tr>
                <th>Postsubstantive qq</th>
                <td>
                    <xsl:value-of select="count($qq-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/>
                </td>
            </tr>
            <tr>
                <th scope="row">Number of determining adjectives</th>
                <td>
                    <xsl:value-of select="count($determining-adjectives)"/>
                </td>
            </tr>
            <tr>
                <th>Presubstantive determining</th>
                <td>
                    <xsl:value-of select="count($determining-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/>
                </td>
            </tr>
            <tr>
                <th>Postsubstantive determining</th>
                <td>
                    <xsl:value-of select="count($determining-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template name="adjective-semantics-list">
        <table class="tablesorter">
            <thead>
                <tr>
                    <th>Adjective lemma</th>
                    <th>Type</th>
                    <th>Total count</th>
                    <th>Presubstantive</th>
                    <th>Postsubstantive</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="/aggregation/inventory/item[xs:integer(@count-before-substantive) &gt; 0 or xs:integer(@count-after-substantive) &gt; 0]">
                    <tr>
                        <td>
                            <a href="{kiln:url-for-match('filter-sentences-by-lemma-text', ($corpus, $text, @lemma), 0)}"><xsl:value-of select="@lemma"/></a>
                        </td>
                        <td>
                            <xsl:value-of select="@type"/>
                        </td>
                        <td>
                            <xsl:value-of select="sum((xs:integer(@count-before-substantive), xs:integer(@count-after-substantive)))"/>
                        </td>
                        <td>
                            <xsl:value-of select="@count-before-substantive"/>
                        </td>
                        <td>
                            <xsl:value-of select="@count-after-substantive"/>
                        </td>
                    </tr>
                </xsl:for-each>                        
            </tbody>
        </table>
    </xsl:template>
    
</xsl:stylesheet>

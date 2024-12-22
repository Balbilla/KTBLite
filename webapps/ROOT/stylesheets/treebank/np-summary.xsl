<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="utils.xsl"/>
    
    <xsl:template name="np-summary">
        <xsl:for-each select="/aggregation/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='text_corpus']/int">
            <xsl:call-template name="corpus-summary"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="corpus-summary">
        <xsl:variable name="corpus" select="@name"/>
        <xsl:variable name="result-rows" select="/aggregation/response/result/doc[str[@name='text_corpus'] = $corpus]"/>  
        <h2><xsl:value-of select="$corpus"/></h2>
        <table class="tablesorter">
            <thead>
                <tr>
                    <th>Century</th>
                    <th>Tokens</th>
                    <th>NPs</th>
                    <th>MMNPs</th>
                    <th>% of NPs</th>
                    <th>MANPs</th>
                    <th>% of MMNPs</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each-group select="$result-rows" group-by="arr[@name='text_century']/str[1]">
                    <xsl:variable name="mmnp-count" select="count(current-group()[bool[@name='np_has_multiple_modifiers'] = 'true'])"/>
                    <xsl:variable name="manp-count" select="count(current-group()[bool[@name='np_has_multiple_adjective_modifiers'] = 'true'])"/>
                    <tr>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>
                        </td>
                        <td>
                            
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group())"/>
                        </td>
                        <td>
                            <xsl:value-of select="$mmnp-count"/>
                        </td>
                        <td>
                            <xsl:value-of select="tb:display-percentage($mmnp-count, count(current-group()))"/>
                        </td>
                        <td>
                            <xsl:value-of select="$manp-count"/>
                        </td>
                        <td>
                            <xsl:value-of select="tb:display-percentage($manp-count, $mmnp-count)"/>
                        </td>
                    </tr>
                </xsl:for-each-group>
            </tbody>
        </table>
        
        <table class="tablesorter">
            <thead>
                <tr>
                    <th>Genre</th>
                    <th>Tokens</th>
                    <th>NPs</th>
                    <th>MMNPs</th>
                    <th>% of NPs</th>
                    <th>MANPs</th>
                    <th>% of MMNPs</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each-group select="$result-rows" group-by="arr[@name='text_genre']/str[1]">
                    <xsl:variable name="mmnp-count" select="count(current-group()[bool[@name='np_has_multiple_modifiers'] = 'true'])"/>
                    <xsl:variable name="manp-count" select="count(current-group()[bool[@name='np_has_multiple_adjective_modifiers'] = 'true'])"/>
                    <tr>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>
                        </td>
                        <td>
                            
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group())"/>
                        </td>
                        <td>
                            <xsl:value-of select="$mmnp-count"/>
                        </td>
                        <td>
                            <xsl:value-of select="tb:display-percentage($mmnp-count, count(current-group()))"/>
                        </td>
                        <td>
                            <xsl:value-of select="$manp-count"/>
                        </td>
                        <td>
                            <xsl:value-of select="tb:display-percentage($manp-count, $mmnp-count)"/>
                        </td>
                    </tr>
                </xsl:for-each-group>
            </tbody>
        </table>
        
        <h3>Subtree contour</h3>
        <table class="tablesorter">
            <thead>
                <tr>
                    <th colspan="6">Preceding subtrees</th>
                    <th colspan="6">Following subtrees</th>
                </tr>
                <tr>
                    <th>Century</th>
                    <th>Single</th>
                    <th>Plateau</th>
                    <th>Ascending</th>
                    <th>Descending</th>
                    <th>Mixed</th>
                    <th>Single</th>
                    <th>Plateau</th>
                    <th>Ascending</th>
                    <th>Descending</th>
                    <th>Mixed</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each-group select="$result-rows" group-by="arr[@name='text_century']/str[1]">
                    <tr>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'single'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'plateau'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'ascending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'descending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'mixed'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'single'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'plateau'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'ascending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'descending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'mixed'])"/>
                        </td>
                    </tr>
                </xsl:for-each-group>
            </tbody>
        </table>
        
        <table class="tablesorter">
            <thead>
                <tr>
                    <th colspan="6">Preceding subtrees</th>
                    <th colspan="6">Following subtrees</th>
                </tr>
                <tr>
                    <th>Genre</th>
                    <th>Single</th>
                    <th>Plateau</th>
                    <th>Ascending</th>
                    <th>Descending</th>
                    <th>Mixed</th>
                    <th>Single</th>
                    <th>Plateau</th>
                    <th>Ascending</th>
                    <th>Descending</th>
                    <th>Mixed</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each-group select="$result-rows" group-by="arr[@name='text_genre']/str[1]">
                    <tr>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'single'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'plateau'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'ascending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'descending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_preceding_subtree_contour'] = 'mixed'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'single'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'plateau'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'ascending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'descending'])"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_following_subtree_contour'] = 'mixed'])"/>
                        </td>
                    </tr>
                </xsl:for-each-group>
            </tbody>
        </table>
        
        <h3>Distribution</h3>
        <table class="tablesorter">
            <thead>
                <tr>
                    <th>Century</th>
                    <th>Only preceding</th>
                    <th>Only following</th>
                    <th>Both sides</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each-group select="$result-rows" group-by="arr[@name='text_century']/str[1]">
                    <xsl:variable name="mmnp-count" select="count(current-group()[bool[@name='np_has_multiple_modifiers'] = 'true'])"/>
                    <tr>
                        <td>
                            <xsl:value-of select="current-grouping-key()"/>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_mmnp_distribution'] = 'only preceding'])"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="tb:display-percentage(count(current-group()[str[@name='np_mmnp_distribution'] = 'only preceding']), $mmnp-count)"/>
                            <xsl:text>)</xsl:text>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_mmnp_distribution'] = 'only following'])"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="tb:display-percentage(count(current-group()[str[@name='np_mmnp_distribution'] = 'only following']), $mmnp-count)"/>
                            <xsl:text>)</xsl:text>
                        </td>
                        <td>
                            <xsl:value-of select="count(current-group()[str[@name='np_mmnp_distribution'] = 'both sides'])"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="tb:display-percentage(count(current-group()[str[@name='np_mmnp_distribution'] = 'both sides']), $mmnp-count)"/>
                            <xsl:text>)</xsl:text>
                        </td>
                    </tr>
                </xsl:for-each-group>
            </tbody>
        </table>
    </xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:param name="lemma"/>
    
  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="utils.xsl"/>
  
  <xsl:template name="adjective-lemma-summary">
    <xsl:variable name="full-count" select="/aggregation/response/result/@numFound"/>
    <xsl:variable name="facet-fields" select="/aggregation/response/lst/lst[@name='facet_fields']"/>
    <xsl:variable name="in-noun-phrases" select="$facet-fields/lst[@name='w_is_in_np']/int[@name='true']"/>
    <xsl:variable name="in-hyperbaton" select="$facet-fields/lst[@name='w_is_in_hyperbaton']/int[@name='true']"/>
    <table class="uk-table uk-table-striped">      
      <tr>
        <th scope="row">Full count</th>
        <td>
          <a href="{kiln:url-for-match('word-search', (), 0)}?q={$lemma}">
            <xsl:value-of select="$full-count"/>          
          </a>
        </td>
        <td></td>
      </tr>
      <tr>        
        <th scope="row">In noun phrases</th>
        <td>
          <a href="{kiln:url-for-match('np-search', (), 0)}?np_adjectives={$lemma}">
            <xsl:value-of select="$in-noun-phrases"/>        
          </a>
        </td>        
        <td>
          <xsl:value-of select="tb:display-percentage($in-noun-phrases, $full-count)"/>
          <xsl:text> of all instances</xsl:text>
        </td>
      </tr>
      <tr>
        <th scope="row">In hyperbaton</th>
        <td>
          <a href="{kiln:url-for-match('np-search', (), 0)}?np_hyperbaton_adjectives={$lemma}">
            <xsl:value-of select="$in-hyperbaton"/>          
          </a>
        </td>
        <td>
          <xsl:value-of select="tb:display-percentage($in-hyperbaton, $in-noun-phrases)"/>
          <xsl:text> of instances in the noun phrase</xsl:text>
        </td>
      </tr>      
    </table>
  </xsl:template>  
  
</xsl:stylesheet> 
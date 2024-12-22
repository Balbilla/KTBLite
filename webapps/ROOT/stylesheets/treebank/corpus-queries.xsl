<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:include href="utils.xsl"/>
  
  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>  
   
  <xsl:template name="text-queries">   
    
    <xsl:variable name="corpus" select="/dir:directory/@name"/>
    
        
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Text</th>
          <th>HS principle (<a href="{kiln:url-for-match('hs-noun-phrase-corpus', $corpus, 0)}">corpus</a>)</th>
          <th>Noun phrases (<a href="{kiln:url-for-match('noun-phrase-corpus', $corpus, 0)}">corpus</a>)</th>
          <th>Discontinuous NP (<a href="{kiln:url-for-match('noun-phrase-discontinuity-corpus', $corpus, 0)}">corpus</a>)</th>
          <th>Coordinated adjectives (<a href="{kiln:url-for-match('coordinated-adjectives-corpus', $corpus, 0)}">corpus</a>)</th>
          <th>Hyperbaton (<a href="{kiln:url-for-match('hyperbaton-corpus', $corpus, 0)}">corpus</a>)</th>
          <th>Genitive absolute (<a href="{kiln:url-for-match('genitive-absolute-corpus', $corpus, 0)}">corpus</a>)</th>
          <th>Particle clusters (<a href="{kiln:url-for-match('particle-cluster-corpus', $corpus, 0)}">corpus</a>)</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="/dir:directory/dir:file/@name">
          <xsl:variable name="base-file-name" select="substring-before(., '.xml')"/>
          <tr>
            <td>
              <xsl:value-of select="."/>
            </td>
            <td>
              <a href="{kiln:url-for-match('hs-noun-phrase-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>HS principle</xsl:text>
              </a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-hs-noun-phrase-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text>
              </a>
              <xsl:text>]</xsl:text>
            </td>
            <td>
              <a href="{kiln:url-for-match('noun-phrase-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>Noun Phrases</xsl:text>
              </a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-noun-phrase-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text>
              </a>
              <xsl:text>]</xsl:text>
            </td>
            <td>
              <a href="{kiln:url-for-match('noun-phrase-discontinuity-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>Discontinuous NPs</xsl:text>
              </a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-noun-phrase-discontinuity-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text>
              </a>
              <xsl:text>]</xsl:text>
            </td>
            <td>
              <a href="{kiln:url-for-match('coordinated-adjectives-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>Coordinated adjectives</xsl:text>
              </a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-coordinated-adjectives-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text>
              </a>
              <xsl:text>]</xsl:text>
            </td>
            <td>
              <a href="{kiln:url-for-match('hyperbaton-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>Hyperbaton</xsl:text>
              </a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-hyperbaton-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text>
              </a>
              <xsl:text>]</xsl:text>
            </td>
            <td>
              <a href="{kiln:url-for-match('genitive-absolute-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>Genitive Absolute</xsl:text></a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-genitive-absolute-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text></a>
              <xsl:text>]</xsl:text>
            </td>
            <td>
              <a href="{kiln:url-for-match('particle-cluster-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>Particle clusters</xsl:text>
              </a>
              <xsl:text> [</xsl:text>
              <a href="{kiln:url-for-match('preprocess-particle-cluster-text', ($corpus, $base-file-name), 0)}">
                <xsl:text>PP</xsl:text>
              </a>
              <xsl:text>]</xsl:text>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
  
</xsl:stylesheet>
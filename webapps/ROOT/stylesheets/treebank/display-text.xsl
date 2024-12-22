<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="utils.xsl"/>

  <xsl:variable name="corpus" select="/aggregation/treebank/@corpus"/>
  <xsl:variable name="text" select="/aggregation/treebank/@text"/>

  <xsl:template match="metadata">
    <table class="uk-table">
      <tbody>
        <tr>
          <th scope="row">Text type</th>
          <td>
            <ul class="uk-list">
              <xsl:for-each select="genres/genre">
                <li><xsl:value-of select="."/></li>
              </xsl:for-each>
            </ul>
          </td>
        </tr>
        <tr>
          <th scope="row">Sentence count</th>
          <td><xsl:value-of select="../sentences/@n"/></td>
        </tr>
        <tr>
          <th scope="row">Token count (all)</th>
          <td><xsl:value-of select="../sentences/@token-count-all"/></td>
        </tr>
        <tr>
          <th scope="row">Token count (minus punctuation)</th>
          <td><xsl:value-of select="../sentences/@token-count-actual"/></td>
        </tr>
        <tr>
          <th scope="row">Provenance</th>
          <td><xsl:value-of select="place"/></td>
        </tr>
        <tr>
          <th scope="row">Century</th>
          <td>
            <xsl:value-of select="tb:display-text-date(.)"/>
          </td>
        </tr>
        <!-- Currently this is not dealt with in Papygreek; this is commented out in hopes that better days will come -->
        <!--<tr>
            <th>Handwriting description</th>
            <td><xsl:value-of select="meta_handwriting_description_edition"/></td>
            </tr>
            <tr>
            <th>Professional?</th>
            <td><xsl:value-of select="meta_handwriting_professional"/></td>
            </tr>
            <tr>
            <th>Author name</th>
            <td><xsl:value-of select="meta_author_name"/></td>
            </tr>
            <tr>
            <th>Addressee name</th>
            <td><xsl:value-of select="meta_addressee_name"/></td>
            </tr>-->
      </tbody>
    </table>
    <p><a href="{kiln:url-for-match('preprocess-np-text', ($corpus, $text), 0)}">Preprocessed file</a></p>
    <!--<p>
      <xsl:if test="$corpus='papygreek'">
        
      </xsl:if>
    </p>-->
  </xsl:template>

  <xsl:template match="sentence">
    <xsl:for-each select=".//word">
      <xsl:sort select="number(@id)"/>
      <xsl:value-of select="@form"/>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <a href="{kiln:url-for-match('sentence', ($corpus, $text, @id), 0)}">
      <sup>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>] </xsl:text>
      </sup>
    </a>
  </xsl:template>

</xsl:stylesheet>

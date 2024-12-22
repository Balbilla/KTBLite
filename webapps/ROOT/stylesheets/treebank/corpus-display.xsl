<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href="utils.xsl"/>

  <xsl:template name="summary">
    <section class="uk-section" id="summary">
      <table class="uk-table">
        <tbody>
          <tr>
            <th scope="row">Number of texts</th>
            <td><xsl:value-of select="/aggregation/response/result/@numFound"/></td>
          </tr>
          <tr>
            <th scope="row">Number of sentences</th>
            <td><xsl:value-of select="sum(/aggregation/response/result/doc/int[@name='text_sentences'])"/></td>
          </tr>
          <tr>
            <th scope="row">Number of tokens (all)</th>
            <td><xsl:value-of select="xs:decimal(sum(/aggregation/response/result/doc/int[@name='text_tokens_all']))"/></td>
          </tr>          
          <tr>
            <th scope="row">Number of gap tokens</th>
            <td><xsl:value-of select="sum(/aggregation/response/result/doc/int[@name='text_tokens_gap'])"/></td>
          </tr>
          <tr>
            <th scope="row">Number of punctuation tokens</th>
            <td><xsl:value-of select="sum(/aggregation/response/result/doc/int[@name='text_tokens_punctuation'])"/></td>
          </tr>
          <tr>
            <th scope="row">Number of artificial tokens</th>
            <td><xsl:value-of select="sum(/aggregation/response/result/doc/int[@name='text_tokens_artificial'])"/></td>
          </tr>
          <tr>
            <th scope="row">Number of real tokens (minus punctuation, artificials and gaps)</th>
            <td><xsl:value-of select="xs:decimal(sum(/aggregation/response/result/doc/int[@name='text_tokens']))"/></td>
          </tr>
        </tbody>
      </table>
    </section>
  </xsl:template>

  <xsl:template name="texts">
    <section class="uk-section" id="texts">
      <div class="uk-overflow-auto">
        <div class="tablesorter-pager">
          <form class="uk-form-horizontal">
            <div>
              <img src="{$kiln:assets-path}/images/first.png" class="first" alt="First page" title="First page"/>
              <img src="{$kiln:assets-path}/images/prev.png" class="prev" alt="Previous page" title="Previous page"/>
              <span class="pagedisplay"></span>
              <img src="{$kiln:assets-path}/images/next.png" class="next" alt="Next page" title="Next page"/>
              <img src="{$kiln:assets-path}/images/last.png" class="last" alt="Last page" title="Last page"/>
            </div>
          </form>
        </div>
        <table class="tablesorter">
          <thead>
            <tr>
              <th scope="col">Filename</th>
              <th scope="col">Author</th>
              <th scope="col">Century</th>
              <th scope="col">Genre</th>
              <th scope="col">Language type</th>
              <th scope="col">Language proficiency</th>
              <th scope="col">Source corpus</th>
              <th scope="col">Sentences</th>
              <th scope="col">Tokens</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="/aggregation/response/result/doc"/>
          </tbody>
        </table>
        <div class="tablesorter-pager">
          <form class="uk-form-horizontal">
            <div>
              <img src="{$kiln:assets-path}/images/first.png" class="first" alt="First page" title="First page"/>
              <img src="{$kiln:assets-path}/images/prev.png" class="prev" alt="Previous page" title="Previous page"/>
              <span class="pagedisplay"></span>
              <img src="{$kiln:assets-path}/images/next.png" class="next" alt="Next page" title="Next page"/>
              <img src="{$kiln:assets-path}/images/last.png" class="last" alt="Last page" title="Last page"/>
            </div>
          </form>
        </div>
      </div>
    </section>
  </xsl:template>

  <xsl:template name="queries">
    <section class="uk-section" id="queries">
      <ul>
        <li><a href="{kiln:url-for-match('genitive-absolute-corpus', $corpus, 0)}">Genitive absolute</a></li>
        <li><a href="{kiln:url-for-match('particle-cluster-corpus', $corpus, 0)}">Particle clusters</a></li>
      </ul>
    </section>
  </xsl:template>

  <xsl:template match="doc">
    <tr>
      <td>
        <a href="{kiln:url-for-match('display-text', (str[@name='text_corpus'], str[@name='text_name']), 0)}"><xsl:value-of select="str[@name='text_name']"/></a>
      </td>
      <td><xsl:value-of select="str[@name='text_author']"/></td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='text_century']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='text_genre']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='text_language_type']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td><xsl:value-of select="str[@name='text_language_proficiency']"/></td>
      <td><xsl:value-of select="str[@name='text_corpus']"/></td>
      <td><xsl:value-of select="int[@name='text_sentences']"/></td>
      <td><xsl:value-of select="int[@name='text_tokens']"/></td>
    </tr>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

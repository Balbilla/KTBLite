<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"  
                xmlns:tb="https://papygreek.hum.helsinki.fi/py/"  
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT for displaying Solr results. -->
  
  <xsl:import href="results-to-html.xsl"/>

  <xsl:include href="results-pagination.xsl" />
  
  <!-- Display unselected facets. -->
  <xsl:template match="lst[@name='facet_fields']" mode="search-results">
    <xsl:if test="lst/int">
      <h3>Facets</h3>
      
      <ul data-uk-accordion="">
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$metadata_fields"/>
            <xsl:with-param name="title" select="'Metadata'"/>
          </xsl:call-template>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

    <!-- Display an individual search result. -->
  <xsl:template match="result/doc" mode="search-results" priority="10">
    <xsl:variable name="result-url"/>
    <tr>
      <td>
        <a href="{kiln:url-for-match('display-text', (str[@name='text_corpus'], str[@name='text_name']), 0)}">
          <xsl:value-of select="str[@name='text_name']" />
        </a>
      </td>
      <td data-text="{$number-date}">
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='text_century']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <xsl:value-of select="str[@name='text_corpus']"/>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='text_genre']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>      
      <xsl:variable name="date" select="arr[@name='text_century']/str[1]"/>
      <xsl:variable name="number-date">
        <xsl:choose>
          <xsl:when test="ends-with($date, 'bc')">
            <xsl:value-of select="0 - number(substring-before($date, 'bc'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before($date, 'ad')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <td>
        <xsl:value-of select="str[@name='text_author']"/>
      </td>
      <td>
        <xsl:value-of select="int[@name='text_sentences']"/>
      </td>
      <td>
        <xsl:value-of select="int[@name='text_tokens']"/>
      </td>      
    </tr>
  </xsl:template>

  <!-- Display search results. -->
  <xsl:template match="response/result" mode="search-results">
    <xsl:choose>
      <xsl:when test="number(@numFound) = 0">
        <h3 class="title is-3">No results found</h3>
      </xsl:when>
      <xsl:when test="doc">
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
        <table class="tablesorter uk-hidden">
          <thead>
            <tr>
              <th scope="col">Text</th>                             
              <th scope="col">Century</th>
              <th scope="col">Corpus</th>
              <th scope="col">Genre</th>
              <th scope="col">Author</th>
              <th scope="col">Number of sentences</th>
              <th scope="col">Number of tokens</th>
            </tr>
          </thead>
          <tfoot>
            <tr>
              <th scope="col">Text</th>              
              <th scope="col">Century</th>
              <th scope="col">Corpus</th>
              <th scope="col">Genre</th>
              <th scope="col">Author</th>
              <th scope="col">Number of sentences</th>
              <th scope="col">Number of tokens</th>
            </tr>
          </tfoot>
          <tbody>
            <xsl:apply-templates mode="search-results" select="doc" />
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
            <div>
              <label class="uk-form-label">Jump to page: </label>
              <div class="uk-form-controls">
                <select class="gotoPage uk-select uk-form-width-small"></select>
              </div>
            </div>
            <div>
              <label class="uk-form-label">Rows per page: </label>
              <div class="uk-form-controls">
                <select class="pagesize uk-select uk-form-width-small">
                  <option value="50">50</option>
                  <option value="100">100</option>
                  <option value="500">500</option>
                  <option value="all">All rows</option>
                </select>
              </div>
            </div>
          </form>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>

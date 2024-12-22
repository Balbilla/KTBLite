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

  <xsl:param name="root" select="/" />

  <xsl:include href="results-pagination.xsl" /> 

  <!-- Display an individual search result. -->
  <xsl:template match="result/doc" mode="search-results">    
    <xsl:variable name="np-head-form" select="str[@name='w_form']"/>
    <tr>
      <td>
        <xsl:value-of select="str[@name='w_form']"/>
      </td>
      <td>
        <xsl:for-each select="tokenize(str[@name='np_forms'], '\s+')">
          <xsl:variable name="form" select="substring-after(., '-')"/>
          <span>
            <xsl:attribute name="class">
              <xsl:text>word-pos-</xsl:text>
              <xsl:value-of select="substring-before(., '-')"/>
              <xsl:if test="$form = $np-head-form">
                <xsl:text> word-form</xsl:text>
              </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="$form"/>
          </span>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </td>
      <td>
        <xsl:value-of select="str[@name='w_sentence_text']"/>
      </td>
      <td>
        <a href="{kiln:url-for-match('sentence', (str[@name='text_corpus'], str[@name='text_name'], int[@name='w_sentence_id']), 0)}">
          <xsl:value-of select="str[@name='text_name']" />
        </a>
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
      <td data-text="{$number-date}">
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='text_century']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>      
      <td>
        <xsl:apply-templates select="str[@name='w_pos']" mode="column-display"/>
      </td>      
      <td>
        <xsl:value-of select="str[@name='w_number']"/>
      </td>
      <td>
        <xsl:value-of select="bool[@name='w_has_article']"/>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='np_ag_pos']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='np_ag_number']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='np_ag_position']/str">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='np_ag_is_name']/bool">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <xsl:value-of select="bool[@name='np_ag_has_article']"/>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='np_ag_is_ds']/bool">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <ul class="uk-list">
          <xsl:for-each select="arr[@name='np_ag_tree_size']/int">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </td>
      <td>
        <xsl:value-of select="str[@name='np_tree_pattern']"/>
      </td>
      <td>
        <xsl:value-of select="str[@name='np_simple_pattern']"/>
      </td>
      <td>
        <xsl:value-of select="str[@name='np_span_pattern']"/>
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
        <div class="column-selector-wrapper">
          <input id="column_selector_input" type="checkbox" class="hidden"/>
          <label class="column-selector-button" for="column_selector_input">Column</label>
          <div id="column_selector" class="column-selector">
            <!-- This div is where the column selector is added. -->
          </div>
        </div>
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
              <th scope="col">NP-head</th>
              <th scope="col">Noun phrase</th>
              <th scope="col">Sentence</th>
              <th scope="col">Text</th>
              <th scope="col">Corpus</th>
              <th scope="col">Genre</th>
              <th scope="col">Century</th>
              <th scope="col">Substantive POS</th>
              <th scope="col">Substantive number</th>
              <th scope="col">Substantive has article</th>              
              <th scope="col">AG POS</th>
              <th scope="col">AG number</th>
              <th scope="col">AG position</th>
              <th scope="col">AG is name</th>
              <th scope="col">AG has article</th>
              <th scope="col">AG is DS</th>
              <th scope="col">AG tree size</th>
              <th scope="col">Tree pattern</th>
              <th scope="col">Simple pattern</th>
              <th scope="col">Span pattern</th>
            </tr>
          </thead>
          <tfoot>
            <tr>
              <th scope="col">NP-head</th>
              <th scope="col">Noun phrase</th>
              <th scope="col">Sentence</th>
              <th scope="col">Text</th>
              <th scope="col">Corpus</th>
              <th scope="col">Genre</th>
              <th scope="col">Century</th>
              <th scope="col">Substantive POS</th>
              <th scope="col">Substantive number</th>
              <th scope="col">Substantive has article</th>              
              <th scope="col">AG POS</th>
              <th scope="col">AG number</th>
              <th scope="col">AG position</th>
              <th scope="col">AG is name</th>
              <th scope="col">AG has article</th>
              <th scope="col">AG is DS</th>
              <th scope="col">AG tree size</th>
              <th scope="col">Tree pattern</th>
              <th scope="col">Simple pattern</th>
              <th scope="col">Span pattern</th>       
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
  
  <xsl:template name="classification-table">
    <xsl:variable name="A_all" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A1" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A1-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A2" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A2-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and                    
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A3" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="A3-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="B" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B1-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B1" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B2" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B2-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B3" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="B3-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="C" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'internal'])"/>
    <xsl:variable name="C-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'internal'])"/>
    <xsl:variable name="C1" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'internal'])"/>
    <xsl:variable name="C1-Name" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'false' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'internal'])"/>
    <xsl:variable name="D-postposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="D-Name-postposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="D1-postposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="D1-Name-postposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'postposed'])"/>
    <xsl:variable name="D-preposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="D-Name-preposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'true' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="D1-preposed" select="count(/aggregation/response/result/doc
      [arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="D1-Name-preposed" select="count(/aggregation/response/result/doc
      [bool[@name='np_ag_is_ds'] = 'true' and
      bool[@name='w_has_article'] = 'true' and 
      bool[@name='w_is_proper_name'] = 'true' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <xsl:variable name="E" select="count(/aggregation/response/result/doc
      [str[@name='w_form'] = 'ἔτους' and
      arr[@name='np_ag_is_ds']/bool = 'true' and
      bool[@name='w_has_article'] = 'false' and 
      bool[@name='w_is_proper_name'] = 'false' and
      bool[@name='np_ag_has_article'] = 'false' and 
      arr[@name='np_ag_position']/str = 'preposed'])"/>
    <table class="uk-table">
              <thead>
                <tr>
                  <th scope="col">Classification</th>
                  <th scope="col">Count</th>
                  <th scope="col">Definition</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>A - all postposed contiguous tokens</td>
                  <td>                    
                    <xsl:value-of select="$A_all"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'false', 'true', 'postposed', '')}">all postposed contiguous tokens</a></td>
                </tr>
                <tr>
                  <td>A-Name</td>
                  <td>                    
                    <xsl:value-of select="$A-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'true', 'true', 'postposed', '')}">substantive is proper name</a></td>
                </tr>
                <tr>
                  <td>A1</td>
                  <td>                    
                  <xsl:value-of select="$A1"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'false', 'false', 'postposed', '')}">no article to the genitive</a></td>
                </tr>
                <tr>
                  <td>A1-Name</td>
                  <td>                    
                  <xsl:value-of select="$A1-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'true', 'false', 'postposed', '')}">substantive is proper name, no article to the genitive</a></td>                  
                </tr>
                <tr>
                  <td>A2</td>
                  <td>                    
                    <xsl:value-of select="$A2"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'false', 'true', 'postposed', '')}">no article to the np-head</a></td>
                </tr>
                <tr>
                  <td>A2-Name</td>
                  <td>                    
                    <xsl:value-of select="$A2-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'true', 'true', 'postposed', '')}">substantive is proper name, no article to the np-head</a></td>
                </tr>
                <tr>
                  <td>A3</td>
                  <td>                    
                    <xsl:value-of select="$A3"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'false', 'false', 'postposed', '')}">no article to both</a></td>
                </tr>
                <tr>
                  <td>A3-Name</td>
                  <td>                    
                  <xsl:value-of select="$A3-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'true', 'false', 'postposed', '')}">substantive is proper name, no article to both</a></td>
                </tr>
                <tr>
                  <td>B</td>
                  <td>
                    <xsl:value-of select="$B"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'false', 'true', 'preposed', '')}">all preposed contiguous tokens</a></td>
                </tr>
                <tr>
                  <td>B-name</td>
                  <td>                    
                    <xsl:value-of select="$B-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'true', 'true', 'preposed', '')}">all preposed contiguous tokens, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>B1</td>
                  <td>                    
                    <xsl:value-of select="$B1"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'false', 'false', 'preposed', '')}">no article to the genitive</a></td>
                </tr>
                <tr>
                  <td>B1-Name</td>
                  <td>
                    <xsl:value-of select="$B1-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'true', 'false', 'preposed', '')}">no article to the genitive, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>B2</td>
                  <td>
                    <xsl:value-of select="$B2"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'false', 'true', 'preposed', '')}">no article to the np-head</a></td>
                </tr>
                <tr>
                  <td>B2-Name</td>
                  <td>                    
                    <xsl:value-of select="$B2-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'true', 'true', 'preposed', '')}">no article to the np-head, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>B3</td>
                  <td>                    
                    <xsl:value-of select="$B3"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'false', 'false', 'preposed', '')}">no article to both</a></td>
                </tr>
                <tr>
                  <td>B3-Name</td>
                  <td>                    
                    <xsl:value-of select="$B3-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'false', 'true', 'false', 'preposed', '')}">no article to both, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>C</td>
                  <td>                    
                    <xsl:value-of select="$C"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'false', 'true', 'internal', '')}">internal genitive</a></td>
                </tr>
                <tr>
                  <td>C-Name</td>
                  <td>                    
                    <xsl:value-of select="$C-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'true', 'true', 'internal', '')}">internal genitive, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>C1</td>
                  <td>                    
                    <xsl:value-of select="$C1"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'false', 'false', 'internal', '')}">no article to the genitive</a></td>
                </tr>                
                <tr>
                  <td>C1-Name</td>
                  <td>                    
                    <xsl:value-of select="$C1-Name"/>
                  </td>
                  <td><a href="{tb:get-ag-url('false', 'true', 'true', 'false', 'internal', '')}">no article to the genitive, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>D-postposed</td>
                  <td>                    
                    <xsl:value-of select="$D-postposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'false', 'true', 'postposed', '')}">polydefinite phrase</a></td>
                </tr>
                <tr>
                  <td>D-Name-postposed</td>
                  <td>                    
                    <xsl:value-of select="$D-Name-postposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'true', 'true', 'postposed', '')}">polydefinite phrase, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>D1-postposed</td>
                  <td>                    
                    <xsl:value-of select="$D1-postposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'false', 'false', 'postposed', '')}">polydefinite phrase, no article to the genitive</a></td>
                </tr>
                <tr>
                  <td>D1-Name-postposed</td>
                  <td>                           
                    <xsl:value-of select="$D1-Name-postposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'true', 'true', 'postposed', '')}">polydefinite phrase, no article to the genitive, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>D-preposed</td>
                  <td>                    
                    <xsl:value-of select="$D-preposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'false', 'true', 'preposed', '')}">polydefinite phrase</a></td>
                </tr>
                <tr>
                  <td>D-Name-preposed</td>
                  <td>                    
                    <xsl:value-of select="$D-Name-preposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'true', 'true', 'preposed', '')}">polydefinite phrase, np-head is proper name</a></td>
                </tr>
                <tr>
                  <td>D1-preposed</td>
                  <td>                    
                    <xsl:value-of select="$D1-preposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'false', 'false', 'preposed', '')}">polydefinite phrase, no article to the genitive</a></td>
                </tr>
                <tr>
                  <td>D1-Name-preposed</td>
                  <td>
                    <xsl:value-of select="$D1-Name-preposed"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'true', 'true', 'preposed', '')}">polydefinite phrase, no article to the genitive, np-head is proper name</a></td>
                </tr>               
                <tr>
                  <td>E</td>
                  <td>                    
                    <xsl:value-of select="$E"/>
                  </td>
                  <td><a href="{tb:get-ag-url('true', 'true', 'false', 'true', 'preposed', 'ἔτους')}">standard dating formula, ἔτους num Καίσαρος</a></td>
                </tr>
                <tr>
                  <td>Unclassified</td>
                  <td>
                    <xsl:value-of select="count(/aggregation/response/result/doc) - sum(($A_all, $A-Name, $A1, 
                      $A2, $A2-Name, $A3, $A3-Name, $B, $B-Name, $B1, $B1-Name, $B2, $B2-Name, $B3, $B3-Name,
                      $C, $C-Name, $C1, $C1-Name, $D-postposed, $D-Name-postposed, $D1-postposed, $D1-Name-postposed,
                      $D-preposed, $D-Name-preposed, $D1-preposed, $D1-Name-preposed, $E))"/>
                  </td>
                  <td>unclassified</td>
                </tr>
              </tbody>
            </table>
  </xsl:template>
  
  <xsl:function name="tb:get-ag-url" as="xs:string">
    <xsl:param name="ds"/>
    <xsl:param name="np-head-art"/>
    <xsl:param name="np-head-name"/>
    <xsl:param name="ag-art"/>
    <xsl:param name="ag-position"/>
    <xsl:param name="np-head-form"/>
    <!-- Remove any existing values for the facets that we are going to replace. -->
    <xsl:variable name="new-query-string-parameters" as="xs:string*">
      <xsl:for-each select="$query-string-parameters">
        <xsl:if test="not(starts-with(., 'np_ag_is_ds') or starts-with(., 'w_has_article') or starts-with(., 'w_is_proper_name') or starts-with(., 'np_ag_has_article') or starts-with(., 'np_ag_position') or starts-with(., 'w_form'))">
          <xsl:value-of select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:value-of select="concat('np_ag_is_ds', '=', kiln:escape-for-query-string($ds))"/>
      <xsl:value-of select="concat('w_has_article', '=', kiln:escape-for-query-string($np-head-art))"/>
      <xsl:value-of select="concat('w_is_proper_name', '=', kiln:escape-for-query-string($np-head-name))"/>
      <xsl:value-of select="concat('np_ag_has_article', '=', kiln:escape-for-query-string($ag-art))"/>
      <xsl:value-of select="concat('np_ag_position', '=', kiln:escape-for-query-string($ag-position))"/>
      <xsl:if test="normalize-space($np-head-form)">
        <xsl:value-of select="concat('w_form', '=', kiln:escape-for-query-string($np-head-form))"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="kiln:query-string-from-sequence(
      $new-query-string-parameters, ('start'), 0)"/>
  </xsl:function>
  
  <xsl:template name="display-selected-facet">
    <xsl:param name="name" />
    <xsl:param name="value" />
    <xsl:variable name="name-value-pair">
      <!-- Match the fq parameter as it appears in the query
           string. -->
      <xsl:value-of select="$name" />
      <xsl:text>=</xsl:text>
      <xsl:value-of select="kiln:escape-for-query-string($value)" />
    </xsl:variable>
    <li>
      <xsl:call-template name="display-facet-value">
        <xsl:with-param name="facet-field" select="$name" />
        <xsl:with-param name="facet-value" select="$value" />
      </xsl:call-template>
      <xsl:text> (</xsl:text>
      <!-- Create a link to unapply the facet. -->
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="kiln:string-replace($query-string-at-start,
            $name-value-pair, '')" />
        </xsl:attribute>
        <xsl:text>x</xsl:text>
      </a>
      <xsl:text>)</xsl:text>
    </li>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$query-string-at-start" />
        <xsl:text>&amp;</xsl:text>
        <xsl:value-of select="$name" />
        <xsl:text>=</xsl:text>
        <xsl:value-of select="kiln:escape-for-query-string($value)" />
      </xsl:attribute>
      <xsl:call-template name="display-facet-value">
        <xsl:with-param name="facet-value" select="$value" />
      </xsl:call-template>
    </a>
  </xsl:template>

</xsl:stylesheet>

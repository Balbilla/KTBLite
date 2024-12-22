<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT for displaying Solr results. -->

  <xsl:param name="root" select="/" />

  <xsl:include href="results-pagination.xsl" />

  <!-- Display an unselected facet. -->
  <xsl:template match="int" mode="search-results">
    <xsl:variable name="name" select="../@name" />
    <xsl:variable name="value" select="@name" />
    <!-- List a facet only if it is not selected. -->
    <xsl:if test="not($request/h:parameter[@name=$name]/h:value = $value)">
      <li>
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
        <xsl:call-template name="display-facet-count" />
      </li>
    </xsl:if>
  </xsl:template>

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
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$morphology_fields"/>
            <xsl:with-param name="title" select="'Morphology'"/>
          </xsl:call-template>
        </li>
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$syntax_fields"/>
            <xsl:with-param name="title" select="'Syntax'"/>
          </xsl:call-template>
        </li>
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$semantics_fields"/>
            <xsl:with-param name="title" select="'Semantics'"/>
          </xsl:call-template>
        </li>
        <!--<li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$heaviness_fields"/>
            <xsl:with-param name="title" select="'Heaviness'"/>
          </xsl:call-template>
        </li>-->
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$first_governor_fields"/>
            <xsl:with-param name="title" select="'First Governor'"/>
          </xsl:call-template>
        </li>
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$first_dependent_fields"/>
            <xsl:with-param name="title" select="'First Dependent'"/>
          </xsl:call-template>
        </li>
        <li>
          <xsl:call-template name="display-facet-group">
            <xsl:with-param name="fields" select="$other_fields"/>
            <xsl:with-param name="title" select="'Other'"/>
          </xsl:call-template>
        </li>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="lst[@name='facet_fields']/lst"
                mode="search-results">
    <li>
      <a class="facet-header collapsed">
        <xsl:apply-templates mode="search-results" select="@name" />
      </a>
      <ul class="facet-list collapsed uk-list uk-list-striped">
        <xsl:apply-templates mode="search-results" />
      </ul>
    </li>
  </xsl:template>

  <!-- Display a facet's name. -->
  <xsl:template match="lst[@name='facet_fields']/lst/@name"
                mode="search-results">
    <xsl:call-template name="display-facet-name">
      <xsl:with-param name="name" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- Display an individual search result. -->
  <xsl:template match="result/doc" mode="search-results">
    <xsl:variable name="result-url"/>
    <xsl:variable name="np-head-form" select="str[@name='w_np_head_form']"/>
    <tr>
      <td>
        <xsl:value-of select="str[@name='w_form']"/>
      </td>
      <td>
        <xsl:for-each select="tokenize(str[@name='w_np_forms'], '\s+')">
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
        <xsl:value-of select="str[@name='w_sentence_id_string']"/>
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
        <xsl:value-of select="str[@name='text_corpus']"/>
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
              <th scope="col">Match</th>
              <th scope="col">NP</th>
              <th scope="col">Sentence</th>
              <th scope="col">Text</th>
              <th scope="col">Sentence id</th>
              <th scope="col">Genre</th>
              <th scope="col">Century</th>
              <th scope="col">Corpus</th>
            </tr>
          </thead>
          <tfoot>
            <tr>
              <th scope="col">Match</th>
              <th scope="col">NP</th>
              <th scope="col">Sentence</th>
              <th scope="col">Text</th>
              <th scope="col">Sentence id</th>
              <th scope="col">Genre</th>
              <th scope="col">Century</th>
              <th scope="col">Corpus</th>
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

  <!-- Display selected facets. -->
  <xsl:template match="*[@name='fq']" mode="search-results">
    <h3 class="title is-3">Current filters</h3>

    <ul class="uk-list">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'str'">
          <xsl:apply-templates mode="display-selected-facet" select="." />
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="str">
            <xsl:apply-templates mode="display-selected-facet" select="." />
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

  <!-- Display selected facet. -->
  <xsl:template match="str" mode="display-selected-facet">
    <!-- ORed facets have names and values that are different from
         ANDed facets and must be handled differently. ORed facets
         have the exclusion tag at the beginning of the name, and may
         have multiple values within parentheses separated by " OR
         ". -->
    <xsl:choose>
      <xsl:when test="starts-with(., 'document_type:')"/>
      <xsl:when test="starts-with(., '{!tag')">
        <xsl:call-template name="display-selected-or-facet" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="display-selected-and-facet" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[@name='fq']" mode="search-query">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'str'">
        <xsl:apply-templates mode="search-query-facet" select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="str">
          <xsl:apply-templates mode="search-query-facet" select="." />
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="str" mode="search-query-facet">
    <xsl:choose>
      <xsl:when test="starts-with(., 'document_type:')"/>
      <xsl:when test="starts-with(., '{!tag')">
        <xsl:call-template name="add-or-facet-to-query" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="add-and-facet-to-query" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()" mode="search-results" />

  <xsl:template name="display-facet-count">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template name="display-facet-value">
    <xsl:param name="facet-field" select="''" />
    <xsl:param name="facet-value" />
    <xsl:if test="normalize-space($facet-field)">
      <xsl:call-template name="display-facet-name">
        <xsl:with-param name="name" select="$facet-field"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:value-of select="$facet-value" />
  </xsl:template>

  <!-- Display a selected facet. -->
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
  </xsl:template>

  <!-- Display a selected AND facet. -->
  <xsl:template name="display-selected-and-facet">
    <xsl:variable name="name" select="substring-before(., ':')" />
    <xsl:variable name="value"
                  select="replace(., '^[^:]+:&quot;(.*)&quot;$', '$1')" />
    <xsl:call-template name="display-selected-facet">
      <xsl:with-param name="name" select="$name" />
      <xsl:with-param name="value" select="$value" />
    </xsl:call-template>
  </xsl:template>

  <!-- Display a selected OR facet. -->
  <xsl:template name="display-selected-or-facet">
    <xsl:variable name="name"
                  select="substring-before(substring-after(., '}'), ':')" />
    <xsl:variable name="value" select="substring-before(substring-after(., ':('), ')')" />
    <xsl:for-each select="tokenize($value, ' OR ')">
      <xsl:call-template name="display-selected-facet">
        <xsl:with-param name="name" select="$name" />
        <!-- The facet value has surrounding quotes. -->
        <xsl:with-param name="value" select="substring(., 2, string-length(.)-2)" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="add-facet-to-query">
    <xsl:param name="name" />
    <xsl:param name="value" />
    <input type="hidden" name="{$name}" value="{$value}"/>
  </xsl:template>

  <xsl:template name="add-and-facet-to-query">
    <xsl:variable name="name" select="substring-before(., ':')" />
    <xsl:variable name="value"
                  select="replace(., '^[^:]+:&quot;(.*)&quot;$', '$1')" />
    <xsl:call-template name="add-facet-to-query">
      <xsl:with-param name="name" select="$name" />
      <xsl:with-param name="value" select="$value" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="add-or-facet-to-query">
    <xsl:variable name="name"
                  select="substring-before(substring-after(., '}'), ':')" />
    <xsl:variable name="value" select="substring-before(substring-after(., ':('), ')')" />
    <xsl:for-each select="tokenize($value, ' OR ')">
      <xsl:call-template name="add-facet-to-query">
        <xsl:with-param name="name" select="$name" />
        <!-- The facet value has surrounding quotes. -->
        <xsl:with-param name="value" select="substring(., 2, string-length(.)-2)" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="display-facet-name">
    <xsl:param name="name"/>
    <xsl:for-each select="tokenize($name, '_')">
      <xsl:if test="position() != 1">
        <xsl:choose>
          <xsl:when test=". = 'pos'">
            <xsl:text>PoS</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="upper-case(substring(., 1, 1))" />
            <xsl:value-of select="substring(., 2)" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(position() = last())">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="str[@name='w_pos']" mode="column-display">
    <xsl:choose>
      <xsl:when test=". = 'Verb'">
        <xsl:text>participle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="lower-case(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="display-facet-group">
    <xsl:param name="fields"/>
    <xsl:param name="title"/>
    <a class="uk-accordion-title" href="#">
      <xsl:value-of select="$title"/>
    </a>
    <ul class="uk-accordion-content uk-list">
      <xsl:apply-templates mode="search-results" select="lst[@name=$fields]"/>
    </ul>
  </xsl:template>

  <xsl:function name="kiln:string-replace" as="xs:string">
    <!-- Replaces the first occurrence of $replaced in $input with
         $replacement. -->
    <xsl:param name="input" as="xs:string" />
    <xsl:param name="replaced" as="xs:string" />
    <xsl:param name="replacement" as="xs:string" />
    <xsl:sequence select="concat(substring-before($input, $replaced),
                          $replacement, substring-after($input, $replaced))" />
  </xsl:function>

</xsl:stylesheet>

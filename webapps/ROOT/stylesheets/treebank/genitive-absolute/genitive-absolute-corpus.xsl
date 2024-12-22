<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="../utils.xsl"/>

  <!-- Future Poli: These variables are checked with Jamie (2020-05-04) and they are correct!!! Don't try to "fix them"!!! -->
  <xsl:variable name="constructions" select="/aggregation/xincludes/file/treebank/constructions/construction"/>
  <xsl:variable name="constructions-count" select="count($constructions)"/>
  <xsl:variable name="corpus" select="/aggregation/xincludes/file[1]/treebank/@corpus"/>
  <xsl:variable name="all-sentences" select="/aggregation/xincludes/file/treebank/sentences"/>
  <xsl:variable name="all-sentences-count" select="sum($all-sentences/@n)"/>
  <xsl:variable name="ga-sentences-count" select="count(/aggregation/xincludes/file/treebank/sentences/sentence)"/>

  <xsl:template name="genitive-absolute-summary">
    <section class="uk-margin" id="summary">
      <h2>Summary</h2>
      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="row">Number of sentences</th>
          <td>
            <xsl:value-of select="$all-sentences-count"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Sentences containing genitive absolute constructions</th>
          <td>
            <xsl:value-of select="$ga-sentences-count"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage($ga-sentences-count, $all-sentences-count)"/>
            of all sentences
          </td>
        </tr>
        <tr>
          <th scope="row">Number of files containing genitive absolute</th>
          <td>
            <xsl:value-of select="count(aggregation/xincludes/file/treebank/constructions[construction])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count(aggregation/xincludes/file/treebank/constructions[construction]), count(aggregation/xincludes/file))"/>
            of all files
          </td>
        </tr>
        <tr>
          <th scope="row">Total number of genitive absolute constructions</th>
          <td>
            <xsl:value-of select="$constructions-count"/>
          </td>
        </tr>
        <tr>
          <th scope="row">GA constructions / number of tokens (all)</th>
          <td><xsl:value-of select="tb:display-percentage($constructions-count, sum($all-sentences/@token-count-all))"/></td>
        </tr>
        <tr>
          <th scope="row">GA constructions / number of tokens (minus punctuation)</th>
          <td><xsl:value-of select="tb:display-percentage($constructions-count, sum($all-sentences/@token-count-actual))"/></td>
        </tr>
      </table>
    </section>
    
    <hr class="uk-divider-icon"/>
      
    <section class="uk-margin" id="text-type">
      <h2>Counts by text types</h2>

      <table class="uk-table uk-table-striped">
        <thead>
          <tr>
            <th scope="col">Text type</th>
            <th scope="col">Text count</th>
            <th scope="col">Texts with GA count (% of texts within genre)</th>
            <th scope="col">Count of GAs within genre (% of GAs within the whole corpus)</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each-group select="$constructions" group-by="tb:get-genre(ancestor::treebank)">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:variable name="text-count-for-genre" select="count(/aggregation/xincludes/file[tb:get-genre(treebank) = current-grouping-key()])"/>
            <xsl:variable name="ga-text-count-for-genre" select="count(/aggregation/xincludes/file[tb:get-genre(treebank) = current-grouping-key()][treebank/constructions/construction])"/>
            <xsl:variable name="ga-count-for-genre" select="count(current-group())"/>
            <tr>
              <td><xsl:value-of select="current-grouping-key()"/></td>
              <td><xsl:value-of select="$text-count-for-genre"/></td>
              <td><xsl:value-of select="$ga-text-count-for-genre"/> (<xsl:value-of select="tb:display-percentage($ga-text-count-for-genre, $text-count-for-genre)"/>)</td>
              <td><xsl:value-of select="$ga-count-for-genre"/> (<xsl:value-of select="tb:display-percentage($ga-count-for-genre, $constructions-count)"/>)</td>
            </tr>
          </xsl:for-each-group>
        </tbody>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="agent-pos">
      <h2>Counts by agent POS</h2>

      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="row">All</th>
          <td><xsl:value-of select="sum($constructions/@number-of-agents)"/></td>
        </tr>
        <xsl:if test="$constructions[@noun]">
          <tr>
            <th scope="row">Noun - all</th>
            <td><xsl:value-of select="sum($constructions/@noun)"/></td>
            <td><xsl:value-of select="tb:display-percentage(sum($constructions/@noun), sum($constructions/@number-of-agents))"/></td>
          </tr>
          <tr>
            <th scope="row">Noun - proper</th>
            <td><xsl:value-of select="sum($constructions/@propernoun)"/></td>
            <td><xsl:value-of select="tb:display-percentage(sum($constructions/@propernoun), sum($constructions/@number-of-agents))"/></td>
          </tr>
          <tr>
            <th scope="row">Noun - not proper</th>
            <td><xsl:value-of select="sum($constructions/@noun) - sum($constructions/@propernoun)"/></td>
            <td><xsl:value-of select="tb:display-percentage((sum($constructions/@noun) - sum($constructions/@propernoun)), sum($constructions/@number-of-agents))"/></td>
          </tr>
        </xsl:if>
        <xsl:if test="$constructions[@pronoun]">
          <tr>
            <th scope="row">Pronoun</th>
            <td><xsl:value-of select="sum($constructions/@pronoun)"/></td>
            <td><xsl:value-of select="tb:display-percentage(sum($constructions/@pronoun), sum($constructions/@number-of-agents))"/></td>
          </tr>
        </xsl:if>
        <xsl:if test="$constructions[@adjective]">
          <tr>
            <th scope="row">Adjective</th>
            <td><xsl:value-of select="sum($constructions/@adjective)"/></td>
            <td><xsl:value-of select="tb:display-percentage(sum($constructions/@adjective), sum($constructions/@number-of-agents))"/></td>
          </tr>
        </xsl:if>
        <xsl:if test="$constructions[@numeral]">
          <tr>
            <th scope="row">Numeral</th>
            <td><xsl:value-of select="sum($constructions/@numeral)"/></td>
            <td><xsl:value-of select="tb:display-percentage(sum($constructions/@numeral), sum($constructions/@number-of-agents))"/></td>
          </tr>
        </xsl:if>
        <xsl:if test="$constructions[@verb]">
          <tr>
            <th scope="row">Verb</th>
            <td><xsl:value-of select="sum($constructions/@verb)"/></td>
            <td><xsl:value-of select="tb:display-percentage(sum($constructions/@verb), sum($constructions/@number-of-agents))"/></td>
          </tr>
        </xsl:if>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="number-gender">
      <h2>Counts by participle number and agent gender</h2>

      <xsl:variable name="singular-constructions" select="$constructions[@number='s']"/>
      <xsl:variable name="dual-constructions" select="$constructions[@number='d']"/>
      <xsl:variable name="plural-constructions" select="$constructions[@number='p']"/>
      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="col">Number</th>
          <th scope="col">Gender</th>
          <th scope="col">Count</th>
        </tr>
        <tr>
          <td rowspan="3">Singular</td>
          <td>Masculine</td>
          <td><xsl:value-of select="count($singular-constructions[@masculine])"/></td>
        </tr>
        <tr>
          <td>Feminine</td>
          <td><xsl:value-of select="count($singular-constructions[@feminine])"/></td>
        </tr>
        <tr>
          <td>Neuter</td>
          <td><xsl:value-of select="count($singular-constructions[@neuter])"/></td>
        </tr>
        <tr>
          <td rowspan="3">Dual</td>
          <td>Masculine</td>
          <td><xsl:value-of select="count($dual-constructions[@masculine])"/></td>
        </tr>
        <tr>
          <td>Feminine</td>
          <td><xsl:value-of select="count($dual-constructions[@feminine])"/></td>
        </tr>
        <tr>
          <td>Neuter</td>
          <td><xsl:value-of select="count($dual-constructions[@neuter])"/></td>
        </tr>
        <tr>
          <td rowspan="3">Plural</td>
          <td>Masculine</td>
          <td><xsl:value-of select="count($plural-constructions[@masculine])"/></td>
        </tr>
        <tr>
          <td>Feminine</td>
          <td><xsl:value-of select="count($plural-constructions[@feminine])"/></td>
        </tr>
        <tr>
          <td>Neuter</td>
          <td><xsl:value-of select="count($plural-constructions[@neuter])"/></td>
        </tr>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="participant-order">
      <h2>Counts by participants order</h2>
      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="row">Agent before participle</th>
          <td>
            <xsl:value-of select="count($constructions[@constituents-order='ap'])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@constituents-order='ap']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Participle before agent</th>
          <td>
            <xsl:value-of select="count($constructions[@constituents-order='pa'])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@constituents-order='pa']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Mixed</th>
          <td>
            <xsl:value-of select="count($constructions[@constituents-order='mixed'])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@constituents-order='mixed']), $constructions-count)"/>
          </td>
        </tr>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="sentence-order">
      <h2>Counts by order in sentence</h2>
      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="row">Construction before verb</th>
          <td>
            <xsl:value-of select="count($constructions[@order-in-sentence='cv'])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@order-in-sentence='cv']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Verb before construction</th>
          <td>
            <xsl:value-of select="count($constructions[@order-in-sentence='vc'])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@order-in-sentence='vc']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">CHECK</th>
          <td>
            <xsl:value-of select="count($constructions[@order-in-sentence='CHECK'])"/>
          </td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@order-in-sentence='CHECK']), $constructions-count)"/>
          </td>
        </tr>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="ga-type">
      <h2>Counts by GA type</h2>

      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="col">Type</th>
          <th scope="col">Count</th>
          <th scope="col">Ratio</th>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="label-by-genitive-absolute-type">
              <xsl:with-param name="construction-type" select="'1'"/>
            </xsl:call-template>
          </td>
          <td><xsl:value-of select="count($constructions[@type='1'])"/></td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@type='1']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="label-by-genitive-absolute-type">
              <xsl:with-param name="construction-type" select="'2'"/>
            </xsl:call-template>
          </td>
          <td><xsl:value-of select="count($constructions[@type='2'])"/></td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@type='2']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="label-by-genitive-absolute-type">
              <xsl:with-param name="construction-type" select="'3'"/>
            </xsl:call-template>
          </td>
          <td><xsl:value-of select="count($constructions[@type='3'])"/></td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@type='3']), $constructions-count)"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="label-by-genitive-absolute-type">
              <xsl:with-param name="construction-type" select="'4'"/>
            </xsl:call-template>
          </td>
          <td><xsl:value-of select="count($constructions[@type='4'])"/></td>
          <td>
            <xsl:value-of select="tb:display-percentage(count($constructions[@type='4']), $constructions-count)"/>
          </td>
        </tr>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="distance">
      <h2>Counts by distance</h2>

      <div class="uk-card uk-card-default">
        <p class="uk-card-body uk-text-warning">Add note here about this only
        handling Type 1 instances currently, due to the problem of
        determining the distance between more than two items.</p>
      </div>

      <xsl:choose>
        <xsl:when test="$constructions[@type='1']">
          <table class="tablesorter">
            <thead>
              <tr>
                <th scope="col">Distance (no articles)</th>
                <th scope="col">Subtree distance</th>
                <th scope="col">Intervening words</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each-group select="$constructions[@type='1']" group-by="@constituents-distance">
                <tr>
                  <td>
                    <xsl:value-of select="current-grouping-key()"/>
                  </td>
                  <td>
                    <xsl:value-of select="current-group()/@constituents-distance-subtrees"/>
                  </td>
                  <td>
                    <xsl:value-of select="current-grouping-key()"/>
                  </td>
                </tr>
              </xsl:for-each-group>
            </tbody>
          </table>
        </xsl:when>
        <xsl:otherwise>
          <p>No instances of Type 1 to display distance information for.</p>
        </xsl:otherwise>
      </xsl:choose>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="anomaly">
      <h2>Anomalies</h2>
      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="row">No gender</th>
          <td><xsl:value-of select="count($constructions[not(@masculine or @feminine or @neuter)])"/></td>
          <td>
            <xsl:for-each-group select="$constructions[not(@masculine or @feminine or @neuter)]" group-by="../../@text">
              <xsl:call-template name="display-text-link" >
                <xsl:with-param name="count" select="count(current-group())"/>
                <xsl:with-param name="path" select="current-grouping-key()"/>
              </xsl:call-template>
            </xsl:for-each-group>
          </td>
        </tr>
        <tr>
          <th scope="row">No number</th>
          <td><xsl:value-of select="count($constructions[@number=''])"/></td>
          <td>
            <xsl:for-each-group select="$constructions[@number='']" group-by="../../@text">
              <xsl:call-template name="display-text-link" >
                <xsl:with-param name="count" select="count(current-group())"/>
                <xsl:with-param name="path" select="current-grouping-key()"/>
              </xsl:call-template>
            </xsl:for-each-group>
          </td>
        </tr>
        <tr>
          <th scope="row">No type</th>
          <td><xsl:value-of select="count($constructions[@type=''])"/></td>
          <td>
            <xsl:for-each-group select="$constructions[@type='']" group-by="../../@text">
              <xsl:call-template name="display-text-link" >
                <xsl:with-param name="count" select="count(current-group())"/>
                <xsl:with-param name="path" select="current-grouping-key()"/>
              </xsl:call-template>
            </xsl:for-each-group>
          </td>
        </tr>
      </table>
    </section>

    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="intervening">
      <h2>Intervening words</h2>
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Lemma</th>
            <th scope="col">Count</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each-group select="$all-sentences/sentence//word[@*[starts-with(name(), 'intervenes-')]]" group-by="@lemma">
            <tr>
              <td><xsl:value-of select="current-grouping-key()"/></td>
              <td><xsl:value-of select="count(current-group())"/></td>
            </tr>
          </xsl:for-each-group>
        </tbody>
      </table>
    </section>
  </xsl:template>

  <xsl:template name="genitive-absolute-instances-wo">
    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="word-order">
      <h2>Instances by word order</h2>

      <div class="uk-overflow-auto">
        <table class="tablesorter">
          <thead>
            <tr>
              <th rowspan="2" scope="col">Text</th>
              <th rowspan="2" scope="col">Category</th>
              <th rowspan="2" scope="col">Date</th>
              <th rowspan="2" scope="col">Sentences</th>
              <th rowspan="2" scope="col">GA</th>
              <th colspan="4" scope="col">Type</th>
              <th colspan="3" scope="col">Singular</th><!-- Counts by number and gender -->
              <th colspan="3" scope="col">Plural</th>
              <th colspan="3" scope="col">Word order</th><!-- Order in sentence -->
              <th colspan="3" scope="col">Constituents order</th><!-- Constituents order -->
            </tr>
            <tr>
              <th scope="col">I</th>
              <th scope="col">II</th>
              <th scope="col">III</th>
              <th scope="col">IV</th>
              <th scope="col">m</th>
              <th scope="col">f</th>
              <th scope="col">n</th>
              <th scope="col">m</th>
              <th scope="col">f</th>
              <th scope="col">n</th>
              <th scope="col">cv</th>
              <th scope="col">vc</th>
              <th scope="col">URGH</th>
              <th scope="col">ap</th>
              <th scope="col">pa</th>
              <th scope="col">mixed</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each-group select="$constructions" group-by="../../@text">
              <tr>
                <td><a href="{kiln:url-for-match('genitive-absolute-text', ($corpus, current-grouping-key()), 0)}"><xsl:value-of select="current-grouping-key()"/></a></td>
                <td><xsl:value-of select="tb:get-genre(ancestor::treebank)"/></td>
                <td>
                  <xsl:value-of select="tb:display-text-date(current-group()[1])"/>
                </td>
                <td><xsl:value-of select="current-group()/ancestor::treebank/sentences/@n"/></td>
                <td><xsl:value-of select="count(current-group())"/></td>
                <td><xsl:value-of select="count(current-group()[@type='1'])"/></td>
                <td><xsl:value-of select="count(current-group()[@type='2'])"/></td>
                <td><xsl:value-of select="count(current-group()[@type='3'])"/></td>
                <td><xsl:value-of select="count(current-group()[@type='4'])"/></td>
                <td><xsl:value-of select="count(current-group()[@masculine='true' and @number='s'])"/></td>
                <td><xsl:value-of select="count(current-group()[@feminine='true' and @number='s'])"/></td>
                <td><xsl:value-of select="count(current-group()[@neuter='true' and @number='s'])"/></td>
                <td><xsl:value-of select="count(current-group()[@masculine='true' and @number='p'])"/></td>
                <td><xsl:value-of select="count(current-group()[@feminine='true' and @number='p'])"/></td>
                <td><xsl:value-of select="count(current-group()[@neuter='true' and @number='p'])"/></td>
                <td><xsl:value-of select="count(current-group()[@order-in-sentence='cv'])"/></td>
                <td><xsl:value-of select="count(current-group()[@order-in-sentence='vc'])"/></td>
                <td><xsl:value-of select="count(current-group()[@order-in-sentence='CHECK'])"/></td>
                <td><xsl:value-of select="count(current-group()[@constituents-order='ap'])"/></td>
                <td><xsl:value-of select="count(current-group()[@constituents-order='pa'])"/></td>
                <td><xsl:value-of select="count(current-group()[@constituents-order='mixed'])"/></td>
              </tr>
            </xsl:for-each-group>
          </tbody>
        </table>
      </div>
    </section>
  </xsl:template>

  <xsl:template name="genitive-absolute-instances-agent">
    <hr class="uk-divider-icon"/>

    <section class="uk-margin" id="agent-data">
      <h2>Instances by agents</h2>

      <div class="uk-overflow-auto">
        <table class="tablesorter">
          <thead>
            <tr>
              <th rowspan="2" scope="col">Text</th>
              <th colspan="6" scope="col">Agents</th>
            </tr>
            <tr>
              <th scope="col">All</th>
              <th scope="col">Noun</th>
              <th scope="col">Pronoun</th>
              <th scope="col">Adjective</th>
              <th scope="col">Numeral</th>
              <th scope="col">Verb</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each-group select="$constructions" group-by="../../@text">
              <tr>
                <td><a href="{kiln:url-for-match('genitive-absolute-text', ($corpus, current-grouping-key()), 0)}"><xsl:value-of select="current-grouping-key()"/></a></td>
                <td><xsl:value-of select="sum(current-group()//@number-of-agents)"/></td>
                <td><xsl:value-of select="sum(current-group()//@noun)"/></td>
                <td><xsl:value-of select="sum(current-group()//@pronoun)"/></td>
                <td><xsl:value-of select="sum(current-group()//@adjective)"/></td>
                <td><xsl:value-of select="sum(current-group()//@numeral)"/></td>
                <td><xsl:value-of select="sum(current-group()//@verb)"/></td>
              </tr>
            </xsl:for-each-group>
          </tbody>
        </table>
      </div>
    </section>
  </xsl:template>

</xsl:stylesheet>

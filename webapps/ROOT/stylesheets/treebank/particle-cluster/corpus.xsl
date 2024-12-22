<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="../utils.xsl"/>

  <xsl:template name="particle-cluster-summary">
    <xsl:variable name="corpus" select="/aggregation/xincludes/file[1]/treebank/@corpus"/>

    <section class="uk-section">
      <h2>Summary</h2>

      <table class="uk-table uk-table-striped">
        <tr>
          <th scope="row">Number of sentences</th>
          <td>
            <xsl:value-of select="sum(/aggregation/xincludes/file/treebank/sentences/@n)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Number of tokens all</th>
          <td>
            <xsl:value-of select="sum(/aggregation/xincludes/file/treebank/sentences/@token-count-all)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Number of tokens minus punctuation</th>
          <td>
            <xsl:value-of select="sum(aggregation/xincludes/file/treebank/sentences/@token-count-actual)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Particle clusters</th>
          <td>
            <xsl:value-of select="count(aggregation/xincludes/file/treebank/constructions/construction)"/>
          </td>
        </tr>
      </table>
    </section>

    <section class="uk-section">
      <h2>Attested particles</h2>
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Lemma</th>
            <th scope="col">Counts</th>
            <th scope="col">Single</th>
            <th scope="col">Cluster</th>
            <th scope="col">% in clusters</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each-group select="/aggregation/xincludes/file/treebank/sentences/sentence//word[tb:is-particle(.) and not(tb:is-negation(.))]" group-by="@lemma">
            <xsl:variable name="count-all" select="count(current-group())"/>
            <xsl:variable name="count-single" select="count(current-group()[not(@cluster-id)])"/>
            <xsl:variable name="count-cluster" select="count(current-group()[@cluster-id])"/>
            <tr>
              <td>
                <xsl:value-of select="current-grouping-key()"/>
              </td>
              <td>
                <xsl:value-of select="$count-all"/>
              </td>
              <td>
                <xsl:value-of select="$count-single"/>
              </td>
              <td>
                <xsl:value-of select="$count-cluster"/>
              </td>
              <td>
                <xsl:value-of select="format-number($count-cluster div $count-all, '0.##%')"/>
              </td>
            </tr>
          </xsl:for-each-group>
        </tbody>
      </table>
    </section>

    <section class="uk-section">
      <h2>Clusters</h2>
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Lemmata</th>
            <th scope="col">Length</th>
            <th scope="col">Count</th>
            <th scope="col">Text types</th>
            <th scope="col">Texts</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each-group select="/aggregation/xincludes/file/treebank/constructions/construction" group-by="@lemmata">
            <tr>
              <td>
                <xsl:value-of select="current-grouping-key()"/>
              </td>
              <td>
                <xsl:value-of select="current-group()[1]/@cluster-length"/>
              </td>
              <td>
                <xsl:value-of select="count(current-group())"/>
              </td>
              <td>
                <xsl:value-of select="distinct-values(tb:get-genres(current-group()/ancestor::treebank))"/>
              </td>
              <td>
                <xsl:for-each select="distinct-values(current-group()/ancestor::treebank/@text)">
                  <a href="{kiln:url-for-match('particle-cluster-text', ($corpus, .), 0)}">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </a>
                </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each-group>
        </tbody>
      </table>
    </section>

    <section class="uk-section">
      <h2>Text types</h2>
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Text type</th>
            <th scope="col">Clusters</th>
            <th scope="col">Texts</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each-group select="/aggregation/xincludes/file/treebank" group-by="tb:get-genre(.)">
            <tr>
              <td>
                <xsl:value-of select="current-grouping-key()"/>
              </td>
              <td>
                <xsl:for-each-group select="current-group()/constructions/construction" group-by="@lemmata">
                  <xsl:value-of select="current-grouping-key()"/>
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="count(current-group())"/>
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                  </xsl:if>
                </xsl:for-each-group>
              </td>
              <td>
                <xsl:for-each select="current-group()[constructions/construction]/@text">
                  <a href="{kiln:url-for-match('particle-cluster-text', ($corpus, .), 0)}">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </a>
                </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each-group>
        </tbody>
      </table>
    </section>

    <section class="uk-section">
      <h2>Texts</h2>
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Texts</th>
            <th scope="col">Number of clusters</th>
            <th scope="col">Lemmata</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="/aggregation/xincludes/file/treebank/constructions[construction]">
            <tr>
              <td>
                <a href="{kiln:url-for-match('particle-cluster-text', ($corpus, ../@text), 0)}">
                  <xsl:value-of select="../@text"/>
                </a>
              </td>
              <td><xsl:value-of select="count(construction)"/></td>
              <td>
                <xsl:for-each-group select="construction" group-by="@lemmata">
                  <xsl:value-of select="current-grouping-key()"/>
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="count(current-group())"/>
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                  </xsl:if>
                </xsl:for-each-group>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </section>

    <section class="uk-section">
      <h2>Dating</h2>
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Century</th>
            <th scope="col">Text types</th>
            <th scope="col">Clusters</th>
            <th scope="col">Texts</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each-group select="/aggregation/xincludes/file/treebank" group-by="tb:display-text-date(.)">
            <tr>
              <td>
                <xsl:value-of select="current-grouping-key()"/>
              </td>
              <td>
                <xsl:value-of select="distinct-values(tb:get-genres(current-group()))"/>
              </td>
              <td>
                <xsl:for-each-group select="current-group()/constructions/construction" group-by="@lemmata">
                  <xsl:value-of select="current-grouping-key()"/>
                  <xsl:text> [</xsl:text>
                  <xsl:value-of select="count(current-group())"/>
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                  </xsl:if>
                </xsl:for-each-group>
              </td>
              <td>
                <xsl:for-each select="current-group()[constructions/construction]/@text">
                  <a href="{kiln:url-for-match('particle-cluster-text', ($corpus, .), 0)}">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </a>
                </xsl:for-each>
              </td>
            </tr>
          </xsl:for-each-group>
        </tbody>
      </table>
    </section>
  </xsl:template>

</xsl:stylesheet>

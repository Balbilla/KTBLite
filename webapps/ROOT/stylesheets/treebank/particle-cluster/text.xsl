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
    <h2>Summary</h2>

    <a href="{kiln:url-for-match('preprocess-particle-cluster-text', (/aggregation/treebank/@corpus, /aggregation/treebank/@text), 0)}">Preprocessed file</a>

    <table>
      <tr>
        <th>Type of document</th>
        <td><xsl:value-of select="tb:get-genre(/aggregation/treebank)"/></td>
      </tr>
      <tr>
        <th>Number of sentences</th>
        <td>
          <xsl:value-of select="aggregation/treebank/sentences/@n"/>
        </td>
      </tr>
      <tr>
        <th>Number of tokens all</th>
        <td>
          <xsl:value-of select="aggregation/treebank/sentences/@token-count-all"/>
        </td>
      </tr>
      <tr>
        <th>Number of tokens minus punctuation</th>
        <td>
          <xsl:value-of select="aggregation/treebank/sentences/@token-count-actual"/>
        </td>
      </tr>
    </table>

    <h2>Attested particles</h2>
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Lemma</th>
          <th>Counts</th>
          <th>Single</th>
          <th>Cluster</th>
          <th>% in clusters</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each-group select="/aggregation/treebank/sentences/sentence//word[tb:is-particle(.) and not(tb:is-negation(.))]" group-by="@lemma">
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

    <h2>Particle clusters</h2>
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Cluster</th>
          <th>Length</th>
          <th>Counts</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each-group select="/aggregation/treebank/constructions/construction" group-by="@lemmata">
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
          </tr>
        </xsl:for-each-group>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="particle-cluster-instances">
    <h2>Instances</h2>
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Cluster</th>
          <th>Sentence</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="/aggregation/treebank/constructions/construction">
          <tr>
            <td>
              <xsl:value-of select="@lemmata"/>
            </td>
            <td>
              <xsl:apply-templates select="../../sentences/sentence[@id = current()/@sentence]">
                <xsl:with-param name="cluster-id" select="@cluster-id"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>

    </table>
  </xsl:template>

  <xsl:template match="sentence">
    <xsl:param name="cluster-id"/>
    <xsl:apply-templates select=".//word">
      <xsl:sort select="number(@id)"/>
      <xsl:with-param name="cluster-id" select="$cluster-id"/>
    </xsl:apply-templates>
    <xsl:text> [</xsl:text>
    <a href="{kiln:url-for-match('sentence', (../../@corpus, ../../@text, @id), 0)}">
      <xsl:value-of select="@id"/>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="word">
    <xsl:param name="cluster-id"/>
    <xsl:choose>
      <xsl:when test="@cluster-id = $cluster-id">
        <!-- css in ROOT/assets/styles/site.css written by Jamie -->
        <span class="particle-in-cluster">
          <xsl:value-of select="@form"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@form"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>

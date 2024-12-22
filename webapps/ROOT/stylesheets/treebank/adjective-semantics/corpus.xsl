<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="../noun-phrase-common-display.xsl"/>
  <xsl:include href="../utils.xsl"/>

  <!-- Because we have an inventory for each text, these node sets may contain duplicate lemmata. That's fine here,
       because we want the data for each individual text, BUT needs to be accounted for when counting the instances! -->

  <xsl:variable name="appearing-adjectives" select="/aggregation/inventory/item"/>
  <xsl:variable name="qq-adjectives" select="$appearing-adjectives[@type='qq']"/>
  <xsl:variable name="determining-adjectives" select="$appearing-adjectives[@type='determining']"/>
  <xsl:variable name="uncategorized-adjectives" select="$appearing-adjectives[not(@type)]"/>
  <xsl:variable name="ethnotoponyms" select="$appearing-adjectives[@ethnotoponym='true']"/>

  <xsl:template name="adjective-semantics-summary">
    <h2>Summary</h2>

    <table class="uk-table">
      <tbody>
        <tr>
          <th scope="row">Number of sentences</th>
          <td>
            <xsl:value-of select="/aggregation/inventory/@number-of-sentences"/>
          </td>
        </tr>
      </tbody>
    </table>

    <table class="uk-table">
      <thead>
        <tr>
          <th scope="col"></th>
          <th scope="col">Number of lemmata</th>
          <th scope="col">Number of instances</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th scope="row">All adjectives</th>
          <td>
            <xsl:value-of select="count($appearing-adjectives)"/>
          </td>
          <td>
            <xsl:value-of select="sum($appearing-adjectives/@count-of-instances)"/>
          </td>
        </tr>
        <tr>
          <th scope="row">Prenominal adjectives</th>
          <td><xsl:value-of select="count($appearing-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($appearing-adjectives/@count-before-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Postnominal adjectives</th>
          <td><xsl:value-of select="count($appearing-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($appearing-adjectives/@count-after-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Uncategorized adjectives</th>
          <td><xsl:value-of select="count($uncategorized-adjectives)"/></td>
          <td><xsl:value-of select="sum($uncategorized-adjectives/@count-of-instances)"/></td>
        </tr>
        <tr>
          <th scope="row">Presubstantive uncategorized</th>
          <td><xsl:value-of select="count($uncategorized-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($uncategorized-adjectives/@count-before-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Postsubstantive uncategorized</th>
          <td><xsl:value-of select="count($uncategorized-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($uncategorized-adjectives/@count-after-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">QQ adjectives</th>
          <td><xsl:value-of select="count($qq-adjectives)"/></td>
          <td><xsl:value-of select="sum($qq-adjectives/@count-of-instances)"/></td>
        </tr>
        <tr>
          <th scope="row">Presubstantive qq</th>
          <td><xsl:value-of select="count($qq-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($qq-adjectives/@count-before-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Postsubstantive qq</th>
          <td><xsl:value-of select="count($qq-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($qq-adjectives/@count-after-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Determining adjectives</th>
          <td><xsl:value-of select="count($determining-adjectives)"/></td>
          <td><xsl:value-of select="sum($determining-adjectives/@count-of-instances)"/></td>
        </tr>
        <tr>
          <th scope="row">Presubstantive determining</th>
          <td><xsl:value-of select="count($determining-adjectives[xs:integer(@count-before-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($determining-adjectives/@count-before-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Postsubstantive determining</th>
          <td><xsl:value-of select="count($determining-adjectives[xs:integer(@count-after-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($determining-adjectives/@count-after-substantive)"/></td>
        </tr>
        <tr>
          <th scope="row">Ethnonyms / toponyms (within determining)</th>
          <td><xsl:value-of select="count($ethnotoponyms)"/></td>
          <td><xsl:value-of select="sum($ethnotoponyms/@count-of-instances)"/></td>
        </tr>
        <tr>
          <th>Presubstantive ET</th>
          <td><xsl:value-of select="count($ethnotoponyms[xs:integer(@count-before-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($ethnotoponyms/@count-before-substantive)"/></td>
        </tr>
        <tr>
          <th>Postsubstantive ET</th>
          <td><xsl:value-of select="count($ethnotoponyms[xs:integer(@count-after-substantive) &gt; 0])"/></td>
          <td><xsl:value-of select="sum($ethnotoponyms/@count-after-substantive)"/></td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="adjective-semantics-list">
    <h2>Instances</h2>
    <div class="uk-overflow-auto">
      <table class="tablesorter">
        <thead>
          <tr>
            <th scope="col">Adjective lemma</th>
            <th scope="col">Type</th>
            <th scope="col">Total count</th>
            <th scope="col">Pre-substantive</th>
            <th scope="col">Post-substantive</th>
            <th scope="col">Absolute difference</th>
            <th scope="col">Normalized absolute difference</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="/aggregation/inventory/item" >
            <tr>
              <td><xsl:value-of select="@lemma"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="not(@ethnotoponym)">
                    <xsl:value-of select="@type"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>ET</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:value-of select="@count-of-instances"/>
              </td>
              <td>
                <xsl:value-of select="@count-before-substantive"/>
              </td>
              <td>
                <xsl:value-of select="@count-after-substantive"/>
              </td>
              <td>
                <xsl:value-of select="@absolute-difference-in-counts"/>
              </td>
              <td>
                <xsl:value-of select="format-number(@absolute-difference-in-counts div @count-of-instances, '0.###')"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>

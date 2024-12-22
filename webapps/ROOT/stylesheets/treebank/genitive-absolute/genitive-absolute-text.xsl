<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="../utils.xsl"/>

  <xsl:variable name="constructions" select="/aggregation/treebank/constructions/construction"/>
  
  <xsl:template name="genitive-absolute-summary">
    
    <a href="{kiln:url-for-match('preprocess-genitive-absolute-text', (/aggregation/treebank/@corpus, /aggregation/treebank/@text), 0)}">Preprocessed file</a>
    
    <h2>Summary</h2>
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
        <th>Sentences containing genitive absolute constructions</th>
        <td>
          <xsl:value-of select="count(aggregation/treebank/sentences/sentence)"/>
        </td>
      </tr>
      <tr>
        <th>Total number of genitive absolute constructions</th>
        <td>
          <xsl:value-of select="count(aggregation/treebank/constructions/construction)"/>
        </td>
      </tr>
    </table>
    
    <h4>Counts of constructions by number and gender</h4>
    <p>These are numbers representing how many constructions involve agents in m, f, or n. Actual numbers of agents by gender follow below.</p>
    <xsl:variable name="singular-constructions" select="$constructions[@number='s']"/>
    <xsl:variable name="dual-constructions" select="$constructions[@number='d']"/>
    <xsl:variable name="plural-constructions" select="$constructions[@number='p']"/>
    <table>
      <tr>
        <th>Number</th>
        <th>Gender</th>
        <th>Count</th>
      </tr>
      <tr>
        <th rowspan="3">Singular</th>
        <th>Masculine</th>
        <td><xsl:value-of select="count($singular-constructions[@masculine])"/></td>
      </tr>
      <tr>
        <th>Feminine</th>
        <td><xsl:value-of select="count($singular-constructions[@feminine])"/></td>
      </tr>
      <tr>
        <th>Neuter</th>
        <td><xsl:value-of select="count($singular-constructions[@neuter])"/></td>
      </tr>
      <tr>
        <th rowspan="3">Dual</th>
        <th>Masculine</th>
        <td><xsl:value-of select="count($dual-constructions[@masculine])"/></td>
      </tr>
      <tr>
        <th>Feminine</th>
        <td><xsl:value-of select="count($dual-constructions[@feminine])"/></td>
      </tr>
      <tr>
        <th>Neuter</th>
        <td><xsl:value-of select="count($dual-constructions[@neuter])"/></td>
      </tr>
      <tr>
        <th rowspan="3">Plural</th>
        <th>Masculine</th>
        <td><xsl:value-of select="count($plural-constructions[@masculine])"/></td>
      </tr>
      <tr>
        <th>Feminine</th>
        <td><xsl:value-of select="count($plural-constructions[@feminine])"/></td>
      </tr>
      <tr>
        <th>Neuter</th>
        <td><xsl:value-of select="count($plural-constructions[@neuter])"/></td>
      </tr>
    </table>
    <h4>Counts by type</h4>
    <table>
      <tr>
        <th>Type</th>
        <th>Count</th>
      </tr>
      <tr>
        <th>
          <xsl:call-template name="label-by-genitive-absolute-type">
            <xsl:with-param name="construction-type" select="'1'"/>
          </xsl:call-template>
        </th>
        <td><xsl:value-of select="count($constructions[@type='1'])"/></td>
      </tr>
      <tr>
        <th>
          <xsl:call-template name="label-by-genitive-absolute-type">
            <xsl:with-param name="construction-type" select="'2'"/>
          </xsl:call-template>
        </th>
        <td><xsl:value-of select="count($constructions[@type='2'])"/></td>
      </tr>
      <tr>
        <th>
          <xsl:call-template name="label-by-genitive-absolute-type">
            <xsl:with-param name="construction-type" select="'3'"/>
          </xsl:call-template>
        </th>
        <td><xsl:value-of select="count($constructions[@type='3'])"/></td>
      </tr>
      <tr>
        <th>
          <xsl:call-template name="label-by-genitive-absolute-type">
            <xsl:with-param name="construction-type" select="'4'"/>
          </xsl:call-template>
        </th>
        <td><xsl:value-of select="count($constructions[@type='4'])"/></td>
      </tr>
    </table>
    
    <h4>Agent POS</h4>
    <table>
      <tr>
        <th>All</th>
        <td><xsl:value-of select="sum($constructions/@number-of-agents)"/></td>
      </tr>
      <xsl:if test="$constructions[@noun]">
        <tr>
          <th>Noun - all</th>
          <td><xsl:value-of select="sum($constructions/@noun)"/></td>
        </tr>
        <tr>
          <th>Noun - proper</th>
          <td><xsl:value-of select="sum($constructions/@propernoun)"/></td>
        </tr>
        <tr>
          <th>Noun - not proper</th>
          <td><xsl:value-of select="sum($constructions/@noun) - sum($constructions/@propernoun)"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="$constructions[@pronoun]">
        <tr>
          <th>Pronoun</th>
          <td><xsl:value-of select="sum($constructions/@pronoun)"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="$constructions[@adjective]">
        <tr>
          <th>Adjective</th>
          <td><xsl:value-of select="sum($constructions/@adjective)"/></td>
        </tr>
      </xsl:if>  
      <xsl:if test="$constructions[@numeral]">
        <tr>
          <th>Numeral</th>
          <td><xsl:value-of select="sum($constructions/@numeral)"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="$constructions[@verb]">
        <tr>
          <th>Verb</th>
          <td><xsl:value-of select="sum($constructions/@verb)"/></td>
        </tr>
      </xsl:if>
    </table>
    
    <h4>Anomalies</h4>
    <table>
      <tr>
        <th>No gender</th>
        <td><xsl:value-of select="count($constructions[not(@masculine or @feminine or @neuter)])"/></td>
        <td>
          <xsl:for-each-group select="$constructions[not(@masculine or @feminine or @neuter)]" group-by="../../@file">
            <xsl:call-template name="display-text-link" >
              <xsl:with-param name="count" select="count(current-group())"/>
              <xsl:with-param name="path" select="current-grouping-key()"/>
            </xsl:call-template>
          </xsl:for-each-group>
        </td>
      </tr>
      <tr>
        <th>No number</th>
        <td><xsl:value-of select="count($constructions[@number=''])"/></td>
      </tr>
      <tr>
        <th>No type</th>
        <td><xsl:value-of select="count($constructions[@type=''])"/></td>
      </tr>
    </table>
    
    <h4>Counts by distance for type 1 constructions</h4>
    <table class="tablesorter">
      <thead>
        <tr>
          <th scope="col">Distance (no articles)</th>
          <th scope="col">Subtree distance</th>
          <th scope="col">Intervening words</th>
          <th scope="col">Sentence</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$constructions[@type='1']">
          <tr>
            <td>
              <xsl:value-of select="@constituents-distance"/>
            </td>
            <td>
              <xsl:value-of select="@constituents-distance-subtree"/>
            </td>
            <td>
              <xsl:value-of select="count(../../sentences/sentence[@id = current()/@sentence]//word[@*[name() = concat('intervenes-', current()/@group)]])"/>
            </td>       
            <td>
              <a href="{kiln:url-for-match('sentence', (../../@corpus, ../../@text, @sentence), 0)}">sentence</a>
            </td>
          </tr>
       </xsl:for-each>
     </tbody>
   </table>
    
   <h4>Intervening words</h4>
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Lemma</th>
          <th>Instances</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each-group select="/aggregation/treebank/sentences/sentence//word[@*[starts-with(name(), 'intervenes-')]]" group-by="@lemma">
          <tr>
            <td><xsl:value-of select="current-grouping-key()"/></td>
            <td><xsl:value-of select="count(current-group())"/></td>
          </tr>
        </xsl:for-each-group>
      </tbody>
    </table>

  </xsl:template>
  
    
  
  <xsl:template name="genitive-absolute-instances">
    <h2>Instances</h2>
    <table>
      <thead>
        <tr>
          <th scope="col">Type</th>
          <th scope="col">Participle number</th>
          <th scope="col">Agent POS</th>
          <th scope="col">Agent gender</th>
          <th scope="col">Instance</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$constructions">
          <tr>
            <td>
              <xsl:value-of select="@type"/>
            </td>
            <td>
              <xsl:value-of select="@number"/>
            </td>
            <td>
              <xsl:if test="@noun">
                <xsl:text>Noun</xsl:text>
              </xsl:if>
              <xsl:if test="@pronoun">
                <xsl:text>Pronoun</xsl:text>
              </xsl:if>
              <xsl:if test="@adjective">
                <xsl:text>Adjective</xsl:text>
              </xsl:if>
              <xsl:if test="@numeral">
                <xsl:text>Numeral</xsl:text>
              </xsl:if>
              <xsl:if test="@verb">
                <xsl:text>Verb</xsl:text>
              </xsl:if>
            </td>
            <td>
              <xsl:if test="@masculine">
                <xsl:text>m</xsl:text>
              </xsl:if>
              <xsl:if test="@feminine">
                <xsl:text>f</xsl:text>
              </xsl:if>
              <xsl:if test="@neuter">
                <xsl:text>n</xsl:text>
              </xsl:if>
            </td>
            <td>
              <xsl:apply-templates select="../../sentences/sentence[@id = current()/@sentence]">
                <xsl:sort select="number(@id)"/>
                <xsl:with-param name="group" select="@group"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </xsl:for-each>

      </tbody>
    </table>    
  </xsl:template>
   
  <xsl:template match="sentence">
    <xsl:param name="group"/>
    <xsl:apply-templates select=".//word">
      <xsl:sort select="number(@id)"/>
      <xsl:with-param name="group" select="$group"/>
    </xsl:apply-templates>
    <xsl:text> [</xsl:text>
    <a href="{kiln:url-for-match('sentence', (../../@corpus, ../../@text, @id), 0)}">
    <xsl:value-of select="@id"/>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:param name="group"/>
    <xsl:choose>
      <xsl:when test="$group = @group">
        <strong><xsl:value-of select="@form"/></strong>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@form"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>
  
</xsl:stylesheet>

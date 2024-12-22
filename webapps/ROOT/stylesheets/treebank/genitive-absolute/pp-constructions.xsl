<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">

  <!-- This stylesheet adds construction elements to the tree containing 
    a summary of the information for each construction:
    ... QAZ - list the other information units
    position of the closest governing verb in relation to the first
    participle from the construction
    ...
  AND gets rid of sentences that don't have constructions in them -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="treebank">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <constructions>
        <xsl:for-each-group select="sentences/sentence//word[@group]" group-by="concat(ancestor::sentence/@id, '-', @group)">
          <xsl:variable name="agents" select="current-group()[@is-agent = 'true']"/>
          <xsl:variable name="participles" select="current-group()[@is-participle = 'true']"/>
          <xsl:variable name="first-participle" select="$participles[1]"/>
          <construction>
            <xsl:attribute name="sentence" select="substring-before(current-grouping-key(), '-')"/>
            <xsl:attribute name="group" select="substring-after(current-grouping-key(), '-')"/>  
            <xsl:call-template name="construction-gender">
              <xsl:with-param name="agents" select="$agents"/>
            </xsl:call-template>
            <xsl:call-template name="construction-constituents-order">
              <xsl:with-param name="agents" select="$agents"/>
              <xsl:with-param name="participles" select="$participles"/>
            </xsl:call-template>
            <xsl:call-template name="order-in-sentence">
              <xsl:with-param name="first-participle" select="$first-participle"/>
              <xsl:with-param name="governing-verb" select="$first-participle/ancestor::sentence//word[@*[name() = concat('governs-', $first-participle/@id)]]"/>
            </xsl:call-template>
            <xsl:attribute name="number" select="tb:get-number(current-group()[tb:is-participle(.)][1])"/>
            <xsl:attribute name="number-of-agents" select="count($agents)"/>
            <xsl:call-template name="agent-pos">
              <xsl:with-param name="agents" select="$agents"/>
            </xsl:call-template>
            <xsl:call-template name="construction-type">
              <xsl:with-param name="agents" select="$agents"/>
              <xsl:with-param name="participles" select="$participles"/>              
            </xsl:call-template>
          </construction>
        </xsl:for-each-group>
      </constructions>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="sentence[not(.//word/@group)]"/>
 
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="construction-constituents-order">
    <xsl:param name="agents"/>
    <xsl:param name="participles"/>
    <xsl:variable name="agent-before-participle" as="xs:boolean*">
      <xsl:for-each select="$agents">
        <xsl:variable name="agent-id" select="xs:integer(@id)"/>
        <xsl:for-each select="$participles">
          <xsl:choose>
            <xsl:when test="$agent-id &lt; xs:integer(@id)">
              <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="false()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>                
    </xsl:variable>
    <xsl:attribute name="constituents-order">
      <xsl:choose>
        <xsl:when test="count(distinct-values($agent-before-participle)) &gt; 1">
          <xsl:text>mixed</xsl:text>
        </xsl:when>
        <xsl:when test="$agent-before-participle[1]">
          <xsl:text>ap</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>pa</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template name="construction-gender">
    <xsl:param name="agents"/>
    <xsl:if test="$agents[tb:is-masculine(.)]">
      <xsl:attribute name="masculine" select="count($agents[tb:is-masculine(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-feminine(.)]">
      <xsl:attribute name="feminine" select="count($agents[tb:is-feminine(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-neuter(.)]">
      <xsl:attribute name="neuter" select="count($agents[tb:is-neuter(.)])"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="agent-pos">
    <xsl:param name="agents"/>
    <xsl:if test="$agents[tb:is-noun(.)]">
      <xsl:attribute name="noun" select="count($agents[tb:is-noun(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-name(.)]">
      <xsl:attribute name="propernoun" select="count($agents[tb:is-name(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-pronoun(.)]">
      <xsl:attribute name="pronoun" select="count($agents[tb:is-pronoun(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-adjective(.)]">
      <xsl:attribute name="adjective" select="count($agents[tb:is-adjective(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-numeral(.)]">
      <xsl:attribute name="numeral" select="count($agents[tb:is-numeral(.)])"/>
    </xsl:if>
    <xsl:if test="$agents[tb:is-verb(.)]">
      <xsl:attribute name="verb" select="count($agents[tb:is-verb(.)])"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="construction-type">
    <xsl:param name="agents"/>
    <xsl:param name="participles"/>
    <xsl:variable name="number-agents" select="count($agents)"/>
    <xsl:variable name="number-participles" select="count($participles)"/>
    <xsl:attribute name="type">
      <xsl:choose>
      <!-- type 1 -->
        <xsl:when test="$number-agents = 1 and $number-participles = 1">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <!-- type 2 -->
        <xsl:when test="$number-agents > 1 and $number-participles = 1">
          <xsl:text>2</xsl:text>
        </xsl:when>
        <!-- type 3 -->
        <xsl:when test="$number-agents = 1 and $number-participles > 1">
          <xsl:text>3</xsl:text>
        </xsl:when>
        <!-- type 4 -->
        <xsl:when test="$number-agents > 1 and $number-participles > 1">
          <xsl:text>4</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template name="order-in-sentence">
    <xsl:param name="first-participle"/>
    <xsl:param name="governing-verb"/>
    <xsl:attribute name="order-in-sentence">
      <xsl:choose>
        <!-- Whenever we have multiple coordinated verbs governing the construction, the results must be checked manually. -->
        <xsl:when test="count($governing-verb) &gt; 1">
          <xsl:text>CHECK</xsl:text>
        </xsl:when>
        <!-- Comparison of strings is bad! Convert to numbers. -->
        <xsl:when test="number($first-participle/@id) &lt; number($governing-verb/@id)">
          <xsl:text>cv</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>vc</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  
  
  
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates the file for form mismatches in
    cases where the postag is the same, in order to spot orthographic
    variation. -->
    
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="metadata">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <pg_language_proficiency>
        <xsl:call-template name="pg_form_mismatch"/><!--
        <xsl:call-template name="articular_infinitive"/>
        <xsl:call-template name="genitive_absolute"/>
        <xsl:call-template name="krasis"/>
        <xsl:call-template name="middle_voice"/>
        <xsl:call-template name="optative"/>
        <xsl:call-template name="particle_men_de"/>        
        <xsl:call-template name="particle_various"/>        
        <xsl:call-template name="subordination"/>
        <xsl:call-template name="subordination_variety"/>-->
      </pg_language_proficiency>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--<xsl:template name="articular_infinitive">
    <xsl:variable name="count" select="count(../sentences/sentence//word[tb:infinitive-has-article(.)])"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 0">
          <xsl:value-of select="-5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <articular_infinitive score="{$score}">
      <xsl:value-of select="$count"/>
    </articular_infinitive>
  </xsl:template>-->
  
  
  <xsl:template name="pg_form_mismatch">
    <xsl:variable name="count-grammatical" select="count(../sentences/sentence//word[@form-mismatch='grammatical'])"/>
    <xsl:variable name="count-orthographical" select="count(../sentences/sentence//word[@form-mismatch='orthographical'])"/>
    <xsl:variable name="score-grammatical">
      <xsl:choose>
        <xsl:when test="$count-grammatical &gt; 0">
          <xsl:value-of select="min(($count-grammatical * 2, 10))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="score-orthographical">
      <xsl:choose>
        <xsl:when test="$count-orthographical &gt; 0">
          <xsl:value-of select="min(($count-orthographical * 2, 10))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <orthographical_mismatch score="{$score-orthographical}">
      <xsl:value-of select="$count-orthographical"/>
    </orthographical_mismatch>
    <grammatical_mismatch score="{$score-grammatical}">
      <xsl:value-of select="$count-grammatical"/>
    </grammatical_mismatch>
  </xsl:template>
   
  
  <!--<xsl:template name="genitive_absolute">
    <xsl:variable name="genitive-participle" select="../sentences/sentence//word[tb:is-participle(.) and @relation=('ADV', 'ADV_CO') and tb:get-case(.) = 'g']"/>
    <xsl:variable name="count" select="count(../sentences/sentence//word[tb:is-genitive(.) and @relation=('SBJ', 'SBJ_CO') 
      and tb:descends-directly-or-solely-via-coordinators(., $genitive-participle)])"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 0">
          <xsl:value-of select="-5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <genitive_absolute score="{$score}">
      <xsl:value-of select="$count"/>
    </genitive_absolute>
  </xsl:template>
  
  
 <xsl:template name="krasis">
    <xsl:variable name="count" select="count(../sentences/sentence//word[@lemma_orig='$'])"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 0">
          <xsl:value-of select="-2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <krasis score="{$score}">
      <xsl:value-of select="$count"/>
    </krasis>
  </xsl:template>
  
  <xsl:template name="middle_voice">
    <xsl:variable name="count" select="count(../sentences/sentence//word[tb:get-voice(.) = 'm'])"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 0">
          <xsl:value-of select="-2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <middle_voice score="{$score}">
      <xsl:value-of select="$count"/>
    </middle_voice>
  </xsl:template>  
  
  <xsl:template name="optative">
    <xsl:variable name="count" select="count(../sentences/sentence//word[tb:get-mood(.) = 'o'])"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 0">
          <xsl:value-of select="-2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <optative score="{$score}">
      <xsl:value-of select="$count"/>
    </optative>
  </xsl:template>
    
  <xsl:template name="particle_men_de">
    <!-\- The very presence of a men-de situation indicates good Greek!  -\->
    <xsl:variable name="count" select="count(../sentences/sentence[descendant::word[@lemma=normalize-unicode('μέν')] 
      and (descendant::word[@lemma=normalize-unicode('δέ')] or 
      following-sibling::sentence[1]//word[@lemma=normalize-unicode('δέ')])])"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 0">
          <xsl:value-of select="-5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <particle_men_de score="{$score}">
      <xsl:value-of select="$count"/>
    </particle_men_de>
  </xsl:template>
  
  <xsl:template name="particle_various">
    <!-\- General particle usage (excluding the omnipresent de) gets points off. 
    This is normalised by the number of sentences. Current value based off of
    the assumption that bgu.16.2626 is an example of good Greek proficiency.
    Normalized for token count actual (different number of sentences in papygreek and 
    zleuven make for differing results if the n of sentences is taken). -\->
    <xsl:variable name="count" select="count(../sentences/sentence//word[tb:is-particle(.) and 
      not(@lemma=(normalize-unicode('δέ'), normalize-space('καί')))]) div ../sentences/@token-count-actual"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt;= 0.5">
          <xsl:value-of select="-5"/>
        </xsl:when>
        <xsl:when test="$count &gt; 0.2 and $count &lt; 0.5">
          <xsl:value-of select="-2"/>
        </xsl:when>
        <xsl:when test="$count &lt;= 0.2 and $count &gt; 0" >
          <xsl:value-of select="2"/>
        </xsl:when>
        <xsl:when test="$count = 0">
          <xsl:value-of select="5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <particle_various score="{$score}">
      <xsl:value-of select="$count"/>
    </particle_various>
  </xsl:template>
  
  <xsl:template name="subordination">
    <!-\- Lack of subordination indicates poor command of the language. -\->
    <xsl:variable name="count" select="max(../sentences/sentence/@subordination-count)"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count = 1">
          <xsl:value-of select="2"/>
        </xsl:when>
        <xsl:when test="$count &gt; 1">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="5"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <subordination_max_count score="{$score}">
      <xsl:value-of select="$count"/>
    </subordination_max_count>
  </xsl:template>
  
  <xsl:template name="subordination_variety">
    <!-\- Lack of subordination indicates poor command of the language. -\->
    <xsl:variable name="subordinate_clause_heads" select="../sentences/sentence//word[tb:is-subordinate-clause-head(.)]"/>
    <xsl:variable name="count_relation_types" select="count(distinct-values($subordinate_clause_heads/@relation))"/>
    <xsl:variable name="subordination_types" as="xs:string*">
      <xsl:for-each select="$subordinate_clause_heads">
        <xsl:choose>
          <xsl:when test="tb:is-participle(.)">
            <xsl:text>participle</xsl:text>
          </xsl:when>
          <xsl:when test="parent::word[tb:is-subordinating-conjunction(.)]">
            <xsl:text>conjunction</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>direct</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="count_subordination_types" select="count(distinct-values($subordination_types))"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count_relation_types &gt;= 3 and $count_subordination_types &gt;= 3">
          <xsl:value-of select="-10"/>
        </xsl:when>
        <xsl:when test="$count_relation_types &gt;= 3 and $count_subordination_types &lt; 3">
          <xsl:value-of select="-5"/>
        </xsl:when>
        <xsl:when test="$count_subordination_types &gt;= 3 and $count_relation_types &lt; 3">
          <xsl:value-of select="-5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <subordination_variety score="{$score}">
      <xsl:text>subordination types - </xsl:text>
      <xsl:value-of select="$count_subordination_types"/>
      <xsl:text>, </xsl:text>
      <xsl:text>relation types - </xsl:text>
      <xsl:value-of select="$count_relation_types"/>
    </subordination_variety>
  </xsl:template>-->
  
  <!-- Disabling this until I can come up with a better way of 
    expressing this rule, which doesn't give me the opposite
    categorisation in papygreek and leuven -->
  <!--<xsl:template name="subordination_max_depth">
    <!-\- Deeper layers of subordination = good Greek.
    Rule for excessive layers added for upz. -\->
    <xsl:variable name="count" select="max(../sentences/sentence/@maximum-subordinate-clauses-depth)"/>
    <xsl:variable name="score">
      <xsl:choose>
        <xsl:when test="$count &gt; 1 and $count &lt; 4">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:when test="$count &gt; 3">
          <xsl:value-of select="5"/>
        </xsl:when>
        <xsl:when test="$count = 0">
          <xsl:value-of select="5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <subordination_max_depth score="{$score}">
      <xsl:value-of select="max(../sentences/sentence/@maximum-subordinate-clauses-depth)"/>
    </subordination_max_depth>
  </xsl:template>-->
  
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates adjectives that participate in hyperbaton -->
  <!-- The logic for the moded templates determining whether a word instigates hyperbaton
    MUST MATCH the logic used in the moded templates in pp-hyperbaton-annotate-other.xsl -->
  
  <!-- This stylesheet only annotates adjectives agreeing with their governing substantive. -->
    
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[tb:is-adjective(.) and @relation = ('ATR', 'ATR_CO', 'ATR_AP', 'ATR_AP_CO') and @np-heads]">
    <xsl:copy>
      <xsl:variable name="agreeing-substantive" select="tb:get-governing-substantive(.)[tb:agrees(., current()) and not(tb:is-artificial(.))]"/>
      <xsl:if test="$agreeing-substantive">
        <xsl:variable name="substantive-position" select="number($agreeing-substantive/@id)"/>
        <xsl:variable name="adjective-position" select="number(@id)"/>
        <xsl:variable name="raw-distance" select="$substantive-position - $adjective-position"/>
        <xsl:variable name="absolute-distance" select="abs($raw-distance)"/>
        <!-- Figures out in which direction we should go looking for the substantive. -->
        <xsl:variable name="step" select="$raw-distance div $absolute-distance"/>
        <xsl:variable name="is-in-hyperbaton" as="xs:boolean">
          <xsl:apply-templates select="ancestor::sentence//word[number(@id) = $adjective-position + $step]" mode="path-to-noun">
            <xsl:with-param name="step" select="$step"/>
            <xsl:with-param name="np-head-id" select="$substantive-position"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="$is-in-hyperbaton">
          <xsl:attribute name="governing-substantive" select="$substantive-position"/>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="@* | node()"/>      
    </xsl:copy>
  </xsl:template>  
  
  <!-- if it's an adjective depending on the same substantive, continue checking for other intervening words; 
  otherwise signal for hyperbaton-->
  <xsl:template match="word[tb:is-adjective(.)]" mode="path-to-noun">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:choose>
      <!-- The @id is a string, so we want to change it to an integer in order to be able to compare it to the
        np-head which is an integer -->
      <xsl:when test="number(tb:get-governing-substantive(.)/@id) = $np-head-id">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="word[tb:is-name(.)]" priority="100" mode="path-to-noun">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:variable name="is-in-name-chain" as="xs:boolean">
      <xsl:apply-templates select="." mode="name-path-to-noun">
        <xsl:with-param name="np-head-id" select="$np-head-id"/>
      </xsl:apply-templates>
    </xsl:variable>    
    <xsl:choose>
      <xsl:when test="number(@id) = $np-head-id">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="$is-in-name-chain">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- This template returns true if the word is part of a chain of names 
  belonging to the same named entity. -->
  <xsl:template match="word[tb:is-name(.)]" mode="name-path-to-noun">
    <xsl:param name="np-head-id"/>
    <xsl:variable name="parent" select="parent::word"/>
    <xsl:choose>
      <xsl:when test="number(@id) = $np-head-id">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:agrees(., $parent) and tb:is-name($parent)">
        <xsl:apply-templates select="$parent" mode="name-path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
        </xsl:apply-templates>
      </xsl:when>      
      <xsl:when test="tb:is-patronym(.)">
        <xsl:apply-templates select="$parent" mode="name-path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="word[tb:is-adverb(.)]" mode="path-to-noun">
    <xsl:value-of select="true()"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-article(.)]" mode="path-to-noun">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
      <xsl:with-param name="np-head-id" select="$np-head-id"/>
      <xsl:with-param name="step" select="$step"/>
    </xsl:apply-templates>      
  </xsl:template>
  
  <!-- This template for participle sometimes clashes with the one for participles. -->
  <xsl:template match="word[tb:is-substantive(.)]" mode="path-to-noun" priority="99">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:variable name="np-head" select="ancestor::sentence//word[number(@id) = $np-head-id]"/>
    <xsl:choose>
      <xsl:when test="number(@id) = $np-head-id">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="tb:agrees(., $np-head) 
        and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="word[tb:is-verb(.)]" mode="path-to-noun">
    <xsl:value-of select="true()"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-participle(.)][@relation=('ATR', 'ATR_CO')]" mode="path-to-noun" priority="90">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:variable name="np-head" select="ancestor::sentence//word[number(@id) = $np-head-id]"/>
    <xsl:choose>
      <xsl:when test="number(@id) = $np-head-id">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="tb:agrees(., $np-head) 
        and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- I need to assign priority in order to avoid clashing with the template matching on adverbs -->
  <xsl:template match="word[@lemma = normalize-unicode('δέ')]" mode="path-to-noun" priority="100">
    <xsl:value-of select="true()"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-particle(.)]" mode="path-to-noun">
    <xsl:value-of select="true()"/>
  </xsl:template>
  
  <!-- Check with results whether this is still true -->
  <xsl:template match="word[tb:is-preposition(.)]" mode="path-to-noun">
    <xsl:value-of select="true()"/>
  </xsl:template>
  
  <xsl:template match="word[@lemma = (normalize-unicode('μή'), normalize-unicode('οὐ'), normalize-unicode('οὐκ'))]" mode="path-to-noun" priority="100">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
      <xsl:with-param name="np-head-id" select="$np-head-id"/>
      <xsl:with-param name="step" select="$step"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="word[tb:is-numeral(.)]" mode="path-to-noun">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:choose>
      <xsl:when test="number(parent::word/@id) = $np-head-id">
        <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
          <xsl:with-param name="np-head-id" select="$np-head-id"/>
          <xsl:with-param name="step" select="$step"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="path-to-noun">
    <xsl:param name="np-head-id"/>
    <xsl:param name="step"/>
    <xsl:apply-templates select="ancestor::sentence//word[number(@id) = number(current()/@id) + $step]" mode="path-to-noun">
      <xsl:with-param name="np-head-id" select="$np-head-id"/>
      <xsl:with-param name="step" select="$step"/>
    </xsl:apply-templates>
  </xsl:template> 
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet> 

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates words causing hyperbaton -->
  <!-- The logic for the moded templates determining whether a word instigates hyperbaton
    MUST MATCH the logic used in the moded templates in pp-hyperbaton-annotate-adjectives.xsl -->
    
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word">
    <xsl:copy>
      <xsl:variable name="suspect-word" select="."/>
      <xsl:variable name="suspect-id" select="number(@id)"/>
      <xsl:variable name="instigated-ids" as="xs:string*">
        <xsl:for-each select="ancestor::sentence//word[@governing-substantive]">
          <xsl:variable name="adjective-id" select="number(@id)"/>
          <xsl:variable name="substantive-id" select="xs:integer(@governing-substantive)"/>
          <!-- Check whether the word is between the adj and the subst - in whichever order they appear. -->
          <xsl:if test="not($suspect-id &lt;= $adjective-id and $suspect-id &lt;= $substantive-id) and not($suspect-id &gt;= $adjective-id and $suspect-id &gt;= $substantive-id)">
            <xsl:apply-templates select="$suspect-word" mode="check-suspect">
              <xsl:with-param name="adjective-id" select="@id"/>
              <xsl:with-param name="substantive-id" select="$substantive-id"/><!-- needed for the case with adjectives depending on other substantives interrupting the dependency -->
            </xsl:apply-templates>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <!-- Look at the first one and if it's true then it's all true - otherwise it complains about the effective boolean value -->
      <xsl:if test="$instigated-ids[1]">
        <xsl:attribute name="instigating" select="$instigated-ids"/>
      </xsl:if>      
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-adjective(.)]" mode="check-suspect">
    <xsl:param name="substantive-id"/>
    <xsl:param name="adjective-id"/>
    <xsl:if test="not(xs:integer(tb:get-governing-substantive(.)/@id) = $substantive-id)">
      <xsl:sequence select="$adjective-id"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="word[tb:is-name(.)]" priority="100" mode="check-suspect">
    <xsl:param name="substantive-id"/>
    <xsl:param name="adjective-id"/>
    <xsl:variable name="parent" select="parent::word"/>
    <xsl:variable name="is-in-name-chain" as="xs:boolean">
      <xsl:apply-templates select="." mode="name-path-to-noun">
        <xsl:with-param name="substantive-id" select="$substantive-id"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="not($is-in-name-chain)">
      <xsl:sequence select="$adjective-id"/>
    </xsl:if>    
  </xsl:template>
  
  <xsl:template match="word[tb:is-name(.)]" mode="name-path-to-noun">
    <xsl:param name="substantive-id"/>
    <xsl:variable name="parent" select="parent::word"/>
    <xsl:choose>
      <xsl:when test="number(@id) = $substantive-id">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="tb:agrees(., $parent) and tb:is-name($parent)">
        <xsl:apply-templates select="$parent" mode="name-path-to-noun">
          <xsl:with-param name="substantive-id" select="$substantive-id"/>
        </xsl:apply-templates>
      </xsl:when>      
      <xsl:when test="tb:is-patronym(.)">
        <xsl:apply-templates select="$parent" mode="name-path-to-noun">
          <xsl:with-param name="substantive-id" select="$substantive-id"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="word[tb:is-adverb(.)]" mode="check-suspect">
    <xsl:param name="adjective-id"/>
    <xsl:sequence select="$adjective-id"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-article(.)]" mode="check-suspect"/>
  
  <!-- This template for participle sometimes clashes with the one for participles. -->  
  <xsl:template match="word[tb:is-substantive(.)]" mode="check-suspect" priority="99">
    <xsl:param name="adjective-id"/>
    <xsl:param name="substantive-id"/>
    <xsl:variable name="substantive" select="ancestor::sentence//word[number(@id) = $substantive-id]"/>
    <xsl:if test="not(tb:agrees(., $substantive) 
      and tb:descends-directly-or-solely-via-coordinators(., $substantive))">
      <xsl:sequence select="$adjective-id"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="word[tb:is-verb(.)]" mode="check-suspect">
    <xsl:param name="adjective-id"/>
    <xsl:sequence select="$adjective-id"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-participle(.)][@relation=('ATR', 'ATR_CO')]" mode="check-suspect" priority="90">
    <xsl:param name="adjective-id"/>
    <xsl:param name="substantive-id"/>
    <xsl:variable name="substantive" select="ancestor::sentence//word[number(@id) = $substantive-id]"/>
    <xsl:if test="not(tb:agrees(., $substantive) 
      and tb:descends-directly-or-solely-via-coordinators(., $substantive))">
      <xsl:sequence select="$adjective-id"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="word[@lemma = normalize-unicode('δέ')]" mode="check-suspect" priority="100">
    <xsl:param name="adjective-id"/>
    <xsl:sequence select="$adjective-id"/>
  </xsl:template>  
  
  <xsl:template match="word[tb:is-particle(.)]" mode="check-suspect">
    <xsl:param name="adjective-id"/>
    <xsl:sequence select="$adjective-id"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-preposition(.)]" mode="check-suspect">
    <xsl:param name="adjective-id"/>
    <xsl:sequence select="$adjective-id"/>
  </xsl:template>
  
  <xsl:template match="word[@lemma = (normalize-unicode('μή'), normalize-unicode('οὐ'), normalize-unicode('οὐκ'))]" mode="check-suspect" priority="100"/>
  
  <xsl:template match="word[tb:is-numeral(.)]" mode="check-suspect">
    <xsl:param name="adjective-id"/>
    <xsl:param name="substantive-id"/>
    <xsl:if test="not(parent::word/@id = $substantive-id)">
      <xsl:sequence select="$adjective-id"/>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="*" mode="check-suspect" />  

  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

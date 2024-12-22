<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet annotates sentences for basic word order patterns. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="sentence">
    <xsl:variable name="patterns" as="xs:string*">
      <xsl:apply-templates select=".//word[not(tb:is-artificial(.))][@relation = ('PRED', 'PRED_CO')]" mode="pattern"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="basic-word-order-pattern">
        <xsl:value-of select="$patterns"/>
      </xsl:attribute>
      <xsl:apply-templates select=".//word[not(tb:is-artificial(.))][@relation = ('PRED', 'PRED_CO')]" mode="extra"/>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[not(tb:is-artificial(.))][@relation = ('PRED', 'PRED_CO')]" mode="pattern">
    <xsl:variable name="subjects" select="tb:get-subjects(.)"/>
    <xsl:variable name="objects" select="tb:get-objects(.)"/>  
    <xsl:variable name="pattern-elements" as="xs:string*">      
      <xsl:for-each select=". | $subjects | $objects">
        <xsl:sort select="number(@id)"/>
        <xsl:choose>
          <xsl:when test="count(. | $subjects) = count($subjects)">
            <xsl:text>S</xsl:text>
          </xsl:when>
          <xsl:when test="count(. | $objects) = count($objects)">
            <xsl:text>O</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>V</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>      
    </xsl:variable>
    <xsl:variable name="pattern">
      <xsl:for-each select="$pattern-elements">
        <xsl:variable name="position" select="position()"/>
        <xsl:choose>
          <xsl:when test="position() = 1">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:when test="not(. = $pattern-elements[$position - 1])">
            <xsl:value-of select="."/>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="$pattern"/>
  </xsl:template>
  
  <xsl:template match="word[not(tb:is-artificial(.))][@relation = ('PRED', 'PRED_CO')]" mode="extra">
    <xsl:variable name="subjects" select="tb:get-subjects(.)"/>
    <xsl:variable name="objects" select="tb:get-objects(.)"/>
    <xsl:attribute name="subjects-pos">
      <xsl:for-each select="$subjects">
        <xsl:value-of select="tb:get-pos(.)"/>
        <xsl:if test="position() != last()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="subjects-case">
      <xsl:for-each select="$subjects">
        <xsl:value-of select="tb:get-case(.)"/>
        <xsl:if test="position() != last()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="infinitive-subjects">
      <xsl:for-each select="$subjects">
        <xsl:choose>
          <xsl:when test="tb:get-mood(.) = 'n'">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="objects-pos">
      <xsl:for-each select="$objects">
        <xsl:value-of select="tb:get-pos(.)"/>
        <xsl:if test="position() != last()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="objects-case">
      <xsl:for-each select="$objects">
        <xsl:value-of select="tb:get-case(.)"/>
        <xsl:if test="position() != last()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="infinitive-objects">
      <xsl:for-each select="$objects">
        <xsl:choose>
          <xsl:when test="tb:get-mood(.) = 'n'">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="tb:get-subjects">
    <xsl:param name="verb"/>
    <xsl:sequence select="$verb/word[not(tb:is-artificial(.))][@relation = ('SBJ', 'SBJ_CO')] | 
      $verb/parent::word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('SBJ', 'SBJ_CO')] | 
      $verb/parent::word[@relation = 'COORD']/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('SBJ', 'SBJ_CO')] |
      $verb/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('SBJ', 'SBJ_CO')]"/>
  </xsl:function>
  
  <xsl:function name="tb:get-objects">
    <xsl:param name="verb"/>
    <xsl:sequence select="$verb/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')] | 
      $verb/parent::word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')] |
      $verb/parent::word[@relation = 'COORD']/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')] |
      $verb/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')]"/>
  </xsl:function>

</xsl:stylesheet>

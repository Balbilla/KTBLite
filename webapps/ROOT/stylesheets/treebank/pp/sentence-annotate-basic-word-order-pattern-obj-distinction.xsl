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
    <xsl:variable name="a-objects" select="tb:get-a-objects(.)"/>  
    <xsl:variable name="d-objects" select="tb:get-d-objects(.)"/>
    <xsl:variable name="pattern-elements" as="xs:string*">      
      <xsl:for-each select=". | $subjects | $a-objects | $d-objects">
        <xsl:sort select="number(@id)"/>
        <xsl:choose>
          <xsl:when test="count(. | $subjects) = count($subjects)">
            <xsl:text>S</xsl:text>
          </xsl:when>
          <xsl:when test="count(. | $a-objects) = count($a-objects)">
            <xsl:text>A</xsl:text>
          </xsl:when>
          <xsl:when test="count(. | $d-objects) = count($d-objects)">
            <xsl:text>D</xsl:text>
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
    <xsl:variable name="a-objects" select="tb:get-a-objects(.)"/>
    <xsl:variable name="d-objects" select="tb:get-d-objects(.)"/>
    <xsl:if test="not(empty($subjects))">
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
      <xsl:attribute name="subjects-name">
        <xsl:for-each select="$subjects">
          <xsl:choose>
            <xsl:when test="tb:is-name(current())">
              <xsl:text>yes</xsl:text>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>no</xsl:text>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
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
    
    <xsl:if test="not(empty($a-objects))">
      <xsl:attribute name="a-objects-pos">
        <xsl:for-each select="$a-objects">
          <xsl:value-of select="tb:get-pos(.)"/>
          <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
      <xsl:attribute name="a-objects-name">
        <xsl:for-each select="$a-objects">
          <xsl:choose>
            <xsl:when test="tb:is-name(current())">
              <xsl:text>yes</xsl:text>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>no</xsl:text>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>  
    
    <xsl:if test="not(empty($d-objects))">
      <xsl:attribute name="d-objects-pos">
        <xsl:for-each select="$d-objects">
          <xsl:value-of select="tb:get-pos(.)"/>
          <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
      <xsl:attribute name="d-objects-name">
        <xsl:for-each select="$d-objects">
          <xsl:choose>
            <xsl:when test="tb:is-name(current())">
              <xsl:text>yes</xsl:text>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>no</xsl:text>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
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
  
  <xsl:function name="tb:get-a-objects">
    <xsl:param name="verb"/>
    <xsl:sequence select="$verb/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'a'] |
      $verb/parent::word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'a'] | 
      $verb/parent::word[@relation = 'COORD']/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'a'] | 
      $verb/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'a']"/>
  </xsl:function>
  
  <xsl:function name="tb:get-d-objects">
    <xsl:param name="verb"/>
    <xsl:sequence select="$verb/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'd'] | 
      $verb/parent::word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'd'] |
      $verb/parent::word[@relation = 'COORD']/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'd'] | 
      $verb/word[@relation = 'COORD']/word[not(tb:is-artificial(.))][@relation = ('OBJ', 'OBJ_CO')][tb:get-case(.) = 'd']"/>
  </xsl:function>

</xsl:stylesheet>

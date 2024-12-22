<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
    
  <xsl:include href="../utils.xsl"/>
  
  <!-- NB! This has quite different logic for figuring
    out the position of the modifiers from the one used
    for single modifiers. I should look over this code
    before using the results for the MMNP chapter! -->
  
  <xsl:template match="word[@np-head='true' and tb:has-article(.) and @multiple-modifiers='true' 
    and (@following-subtree-contour='none' or @preceding-subtree-contour='none')]">
    <!-- 
    Here we record the np-head, its articles, and the modifiers
    by pos in word order and ignore everything else. 
    A = np-head
    B = article belonging to the np-head
    C = modifier
      Cadj = adjective modifier etc.
    -->
    <xsl:variable name="tree-pattern-parts" as="xs:string*">
      <xsl:apply-templates mode="pattern" select="descendant-or-self::word">
        <xsl:sort select="xs:integer(@id)"/>
        <xsl:with-param name="np-head" select="."/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="mmnp-articular-position">
        <xsl:call-template name="determine-position">
          <xsl:with-param name="tree-pattern-parts" select="$tree-pattern-parts"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word" mode="pattern">
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="@id = $np-head/@id">
        <xsl:text>A</xsl:text>
      </xsl:when>
      <!-- This is here so we don't have to worry about articles further down the np-head branch -->
      <xsl:when test="tb:is-article(.)">
        <xsl:if test="tb:is-article-to-word(., $np-head)">
          <xsl:text>B</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="not(tb:descends-directly-or-solely-via-coordinators(., $np-head))"></xsl:when>
      <xsl:when test="@relation=('ATR', 'ATR_CO', 'APOS', 'APOS_CO')">
        <xsl:choose>
          <xsl:when test="tb:is-adjective(.)">Cadj</xsl:when>
          <xsl:when test="tb:is-noun(.)">Cnoun</xsl:when>
          <xsl:when test="tb:is-numeral(.)">Cnum</xsl:when>
          <xsl:when test="tb:is-participle(.)">Cpart</xsl:when>
          <xsl:when test="tb:is-pronoun(.)">Cpron</xsl:when>
          <xsl:when test="tb:is-quantifier(.)">Cquant</xsl:when>          
        </xsl:choose>
      </xsl:when>
      <xsl:when test="tb:is-preposition(.) and .//word[tb:get-first-governor(.)/@id = current()/@id][@relation=('ATR', 'ATR_CO', 'APOS', 'APOS_CO')]">Cpp</xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="determine-position">
    <xsl:param name="tree-pattern-parts"/>
    <xsl:variable name="tree-pattern" select="string-join($tree-pattern-parts, ' ')"/>
    <xsl:choose>
      <xsl:when test="matches($tree-pattern, 'B.*B')">DS</xsl:when>
      <xsl:when test="matches($tree-pattern, 'A.*B')">DS</xsl:when>
      <xsl:when test="matches($tree-pattern, 'C.*B A')">preposed</xsl:when>
      <xsl:when test="matches($tree-pattern, 'B C.*A')">internal</xsl:when>
      <xsl:when test="matches($tree-pattern, 'A C')">postposed</xsl:when>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

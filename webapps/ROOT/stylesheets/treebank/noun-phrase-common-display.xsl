<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
  <xsl:include href="utils.xsl"/>

  <xsl:template match="word[@span-pattern]" mode="display-np-corpus">
    <xsl:variable name="position" select="descendant-or-self::word/@id" as="xs:integer*"/>
    <xsl:variable name="first" select="min($position)"/>
    <xsl:variable name="last" select="max($position)"/>
    <xsl:variable name="span-words" select="ancestor::sentence//word[@id &gt;= $first and @id &lt;= $last]"/>
    <xsl:apply-templates select="$span-words | parent::word[tb:is-preposition(.)]" mode="display-np-word">
      <xsl:sort select="xs:integer(@id)"/>
    </xsl:apply-templates>
    <xsl:variable name="sentence" select="ancestor::sentence"/>
    <xsl:variable name="treebank" select="ancestor::treebank"/>
    <xsl:text>[</xsl:text>
    <a href="{kiln:url-for-match('sentence', ($treebank/@corpus, $treebank/@text, $sentence/@id), 0)}">
      <xsl:value-of select="$treebank/@text"/><xsl:text>, </xsl:text><xsl:value-of select="$sentence/@id"/>
    </a>
    <xsl:text>] [</xsl:text>
    <a href="{kiln:url-for-match('preprocess-noun-phrase-text', ($treebank/@corpus, $treebank/@text), 0)}">
      <xsl:text>pp</xsl:text>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="word[@span-pattern]" mode="display-np-text">
    <xsl:variable name="position" select="descendant-or-self::word/@id" as="xs:integer*"/>
    <xsl:variable name="first" select="min($position)"/>
    <xsl:variable name="last" select="max($position)"/>
    <xsl:variable name="span-words" select="ancestor::sentence//word[@id &gt;= $first and @id &lt;= $last]"/>
    <xsl:apply-templates select="$span-words | parent::word[tb:is-preposition(.)]" mode="display-np-word">
      <xsl:sort select="xs:integer(@id)"/>
    </xsl:apply-templates>
    <xsl:variable name="sentence" select="ancestor::sentence"/>
    <xsl:variable name="treebank" select="ancestor::treebank"/>
    <xsl:text>[</xsl:text>
    <a href="{kiln:url-for-match('sentence', ($treebank/@corpus, $treebank/@text, $sentence/@id), 0)}">
      <xsl:value-of select="$sentence/@id"/>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="word[@mmnp]" mode="display-np-text">
    <xsl:variable name="position" select="descendant-or-self::word/@id" as="xs:integer*"/>
    <xsl:variable name="first" select="min($position)"/>
    <xsl:variable name="last" select="max($position)"/>
    <xsl:variable name="span-words" select="ancestor::sentence//word[@id &gt;= $first and @id &lt;= $last]"/>
    <xsl:apply-templates select="$span-words | parent::word[tb:is-preposition(.)]" mode="display-np-word">
      <xsl:sort select="xs:integer(@id)"/>
    </xsl:apply-templates>
    <xsl:variable name="sentence" select="ancestor::sentence"/>
    <xsl:variable name="treebank" select="ancestor::treebank"/>
    <xsl:text>[</xsl:text>
    <a href="{kiln:url-for-match('sentence', ($treebank/@corpus, $treebank/@text, $sentence/@id), 0)}">
      <xsl:value-of select="$sentence/@id"/>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="word" mode="display-np-word">
    <span class="word-pos-{tb:get-pos(.)}">
      <xsl:value-of select="@form"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template name="display-np-pattern">
    <xsl:param name="pattern"/>
    <xsl:for-each select="tokenize($pattern, '\s+')">
      <xsl:variable name="category" select="substring(., 1, 1)"/>
      <xsl:variable name="name" select="substring(., 2)"/>
      <xsl:variable name="class">
        <xsl:text>NP-pattern-</xsl:text>
        <xsl:choose>
          <xsl:when test="$category = '1'">head</xsl:when>
          <xsl:when test="$category = '2'">agrees</xsl:when>
          <xsl:when test="$category = '3'">disagrees</xsl:when>
          <xsl:when test="$category = '4'">member</xsl:when>
          <xsl:when test="$category = '5'">visitor</xsl:when>
          <xsl:when test="$category = '6'">intruder</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <span class="{$class}">
        <xsl:value-of select="$name"/>
      </span>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- Populate the corpus query document with a Solr-appropriate
       search string derived from the supplied corpus definition
       string ("CDS", as used in URLs).

       A CDS consists of one or more 'tags', all except the first
       prepended with either "+" or "-". The first may have no such
       prefix, in which case it is understood to be prefixed with "+".

       Each "+" part of the CDS specifies a tag (a value in the Solr
       index within the corpus_tags field) that should be present in
       the search results, while each "-" part specifies a tag that
       must not be present.

       Each tag belongs to a category ("author", "century", "genre",
       "source corpus"). Multiple tags within a category are ORed
       together, while tags in different categories are ANDed together.

       When a "-" tag is combined with a "+" tag from the same
       category, the "-" tag is ignored. While unexpected, in practice
       this is not a problem, since tags within a category rarely
       overlap, and where they do (centuries, perhaps in future some
       genres) it does not make sense to have the exclusion. Eg, a
       text designated (due to uncertainty) as 2 or 3 BC should be
       returned as part of a corpus specified by -3bc+2bc.

  -->

  <!-- The corpus definition string. -->
  <xsl:param name="corpus"/>

  <xsl:template match="aggregation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="response"/>

  <xsl:template match="q">
    <xsl:variable name="normalized-definition" as="xs:string">
      <xsl:if test="not(starts-with($corpus, '-') or starts-with($corpus, '+'))">
        <xsl:text>+</xsl:text>
      </xsl:if>
      <xsl:value-of select="$corpus"/>
    </xsl:variable>
    <!-- $1 is a reference to the first matched group formed by the () -->
    <xsl:variable name="separated-definition" select="normalize-space(replace($normalized-definition, '(\+|\-)', ' $1'))" as="xs:string"/>
    <xsl:variable name="corpus-definition-tokens" as="xs:string*" select="tokenize($separated-definition, ' ')"/>
    <xsl:variable name="authors" as="xs:string*">
      <xsl:call-template name="categorize-tokens">
        <xsl:with-param name="tokens" select="$corpus-definition-tokens"/>
        <xsl:with-param name="facet" select="'text_author'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="exclude-authors" as="xs:string">
      <xsl:call-template name="has-exclusion">
        <xsl:with-param name="tokens" select="$authors"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="authors-query" as="xs:string">
      <xsl:call-template name="construct-query">
        <xsl:with-param name="tokens" select="$authors"/>
        <xsl:with-param name="has-exclusion" select="$exclude-authors"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="proficiency" as="xs:string*">
      <xsl:call-template name="categorize-tokens">
        <xsl:with-param name="tokens" select="$corpus-definition-tokens"/>
        <xsl:with-param name="facet" select="'text_language_proficiency'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="exclude-proficiency" as="xs:string">
      <xsl:call-template name="has-exclusion">
        <xsl:with-param name="tokens" select="$proficiency"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="proficiency-query" as="xs:string">
      <xsl:call-template name="construct-query">
        <xsl:with-param name="tokens" select="$proficiency"/>
        <xsl:with-param name="has-exclusion" select="$exclude-proficiency"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="centuries" as="xs:string*">
      <xsl:call-template name="categorize-tokens">
        <xsl:with-param name="tokens" select="$corpus-definition-tokens"/>
        <xsl:with-param name="facet" select="'text_century'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="exclude-centuries" as="xs:string">
      <xsl:call-template name="has-exclusion">
        <xsl:with-param name="tokens" select="$centuries"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="centuries-query" as="xs:string">
      <xsl:call-template name="construct-query">
        <xsl:with-param name="tokens" select="$centuries"/>
        <xsl:with-param name="has-exclusion" select="$exclude-centuries"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="genres" as="xs:string*">
      <xsl:call-template name="categorize-tokens">
        <xsl:with-param name="tokens" select="$corpus-definition-tokens"/>
        <xsl:with-param name="facet" select="'text_genre'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="exclude-genres" as="xs:string">
      <xsl:call-template name="has-exclusion">
        <xsl:with-param name="tokens" select="$genres"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="genres-query" as="xs:string">
      <xsl:call-template name="construct-query">
        <xsl:with-param name="tokens" select="$genres"/>
        <xsl:with-param name="has-exclusion" select="$exclude-genres"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="source-corpora" as="xs:string*">
      <xsl:call-template name="categorize-tokens">
        <xsl:with-param name="tokens" select="$corpus-definition-tokens"/>
        <xsl:with-param name="facet" select="'text_corpus'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="exclude-source-corpora" as="xs:string">
      <xsl:call-template name="has-exclusion">
        <xsl:with-param name="tokens" select="$source-corpora"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="source-corpora-query" as="xs:string">
      <xsl:call-template name="construct-query">
        <xsl:with-param name="tokens" select="$source-corpora"/>
        <xsl:with-param name="has-exclusion" select="$exclude-source-corpora"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="queries" as="xs:string*">
      <xsl:if test="$authors-query">
        <xsl:sequence select="$authors-query"/>
      </xsl:if>
      
      <xsl:if test="$proficiency-query">
        <xsl:sequence select="$proficiency-query"/>
      </xsl:if>
      
      <xsl:if test="$centuries-query">
        <xsl:sequence select="$centuries-query"/>
      </xsl:if>
      <xsl:if test="$genres-query">
        <xsl:sequence select="$genres-query"/>
      </xsl:if>
      <xsl:if test="$source-corpora-query">
        <xsl:sequence select="$source-corpora-query"/>
      </xsl:if>
    </xsl:variable>
    <q>
      <xsl:value-of select="string-join($queries, '+AND+')"/>
    </q>
  </xsl:template>

  <xsl:template name="categorize-tokens">
    <xsl:param name="facet"/>
    <xsl:param name="tokens"/>
    <xsl:variable name="facet-values" select="/aggregation/response
      /lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name=$facet]/int/@name"/>
    <xsl:variable name="has-positive" as="xs:boolean*">
      <xsl:for-each select="$tokens">
        <xsl:if test="substring(., 2) = $facet-values and starts-with(., '+')">
          <xsl:sequence select="true()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="$tokens">
      <!-- we do the substring here to avoid the +/- in front -->
      <xsl:if test="substring(., 2) = $facet-values">
        <xsl:if test="empty($has-positive) or starts-with(., '+')">
          <xsl:sequence select="."/>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="has-exclusion">
    <xsl:param name="tokens"/>
    <xsl:variable name="has-exclusion">
      <xsl:for-each select="$tokens">
        <xsl:if test="starts-with(., '-')">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($has-exclusion, 'true')">
        <xsl:text>-</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="construct-query">
    <xsl:param name="has-exclusion"/>
    <xsl:param name="tokens"/>
    <xsl:variable name="stripped-tokens" as="xs:string*">
      <xsl:for-each select="$tokens">
        <xsl:sequence select="substring(., 2)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(empty($tokens))">
        <xsl:value-of select="concat($has-exclusion, '(', string-join($stripped-tokens, '+OR+'), ')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

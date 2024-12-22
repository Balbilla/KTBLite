<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet annotates each noun phrase head word with the
       patterns for a noun phrase. A pattern is the list of word types
       (noun, preposition, etc) in word order, each type prefixed with
       a number indicating its membership status and agreement with
       the head.

       The patterns added are:

         * tree-pattern: members, including visitor heads but not
                         their descendants;

         * span-pattern: every word between the first and the last member;

         * simple-pattern: as tree-pattern, but with consecutive
           identical elements collapsed into one;
             e.g. tree-pattern="1noun 2adj 2adj" simple-pattern="1noun 2adj"
  -->

  <!-- At the moment this stylesheet is being written I am of the mind that I don't want to see
       emphasizers in the tree pattern as they have no weight on their own but only flip or
       amplify the meaning of other words. This may change in future. -->

  <xsl:include href="../utils.xsl"/>

  <!-- Numbering scheme for each word in a pattern. -->
  <xsl:variable name="head-number" select="1"/>
  <xsl:variable name="agreeing-member-number" select="2"/>
  <xsl:variable name="non-agreeing-member-number" select="3"/>
  <xsl:variable name="non-declinable-member-number" select="4"/>
  <xsl:variable name="visitor-number" select="5"/>
  <xsl:variable name="intruder-number" select="6"/>
  <xsl:variable name="unknown-pos-number" select="7"/>
  <xsl:variable name="adnominal-genitive-number" select="8"/>
  <xsl:variable name="ds-article-number" select="9"/>  
  <xsl:variable name="error-number" select="0"/>

  <xsl:template match="word[@np-head='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="id" select="concat(' ', @id, ' ')"/>
      <xsl:variable name="members" select=". | ancestor::word[contains(@np-heads, $id)] |
        descendant::word[contains(@np-heads, $id)]"/>
      <xsl:variable name="tree-pattern">
        <xsl:apply-templates select="$members" mode="tree-pattern">
          <xsl:with-param name="np-head" select="."/>
          <xsl:sort select="xs:integer(@id)"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:attribute name="tree-pattern" select="normalize-space($tree-pattern)"/>
      <xsl:attribute name="simple-pattern" select="tb:consolidate-tokens(tokenize(normalize-space($tree-pattern), '\s+'), ())"/>
      <xsl:variable name="member-ids" select="$members/@id"/>
      <xsl:variable name="first-member-id" select="min($member-ids)"/>
      <xsl:variable name="last-member-id" select="max($member-ids)"/>     
      <xsl:variable name="span-words" select="ancestor::sentence//word[@id &gt;= $first-member-id and @id &lt;= $last-member-id]"/>
      <xsl:variable name="span-pattern">
        <xsl:apply-templates select="$span-words" mode="span-pattern">
          <xsl:with-param name="np-head" select="."/>
          <xsl:with-param name="include-form" select="true()"></xsl:with-param>
          <xsl:sort select="xs:integer(@id)"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="span-pattern-tokens" select="tb:trim-edges(tb:trim-edges(tokenize(normalize-space($span-pattern), '\s+'), 'left'), 'right')"/>
      <xsl:attribute name="span-pattern">
        <xsl:for-each select="$span-pattern-tokens">
          <xsl:value-of select="substring-before(., '-')"/>
          <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
      <xsl:attribute name="span-forms">
        <xsl:for-each select="$span-pattern-tokens">
          <xsl:value-of select="substring(., 2)"/>
          <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
      <xsl:variable name="ag-tree-sizes" as="xs:integer*">
        <xsl:for-each select="descendant::word[contains(@np-heads, $id)]
          [tb:is-noun(.) and tb:is-genitive(.) and tb:descends-directly-or-solely-via-coordinators(., current())]">
          <xsl:value-of select="count(descendant-or-self::word) - count(word[tb:is-article-to-word(., current())]) - count(word[tb:is-emphasizer(.)])"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="count($ag-tree-sizes) &gt; 0">
        <xsl:attribute name="ag-tree-sizes" select="$ag-tree-sizes"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="word[tb:is-adjective(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="np-head"/>
    <xsl:param name="include-form" select="false()"/>
    <xsl:choose>
      <xsl:when test="@id = $np-head/@id">
        <xsl:value-of select="$head-number"/>
      </xsl:when>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>      
      <xsl:when test="tb:agrees(., $np-head)">
        <xsl:value-of select="$agreeing-member-number"/>
      </xsl:when>      
      <xsl:when test="tb:is-genitive(.) and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:value-of select="$adnominal-genitive-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-agreeing-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>adj</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-adverb(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>    
    <xsl:choose>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-declinable-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>adv</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-article(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>      
      <xsl:when test="tb:agrees(., $np-head) and parent::word/@id = $np-head/@id">
        <xsl:value-of select="$agreeing-member-number"/>
      </xsl:when>
      <!-- Currently this only serves for the examination of the DS with adjectives -->
      <xsl:when test="tb:is-ds-article(., $np-head)">
        <xsl:value-of select="$ds-article-number"/>
      </xsl:when>
      <xsl:when test="tb:is-genitive(.) and not(parent::word/@id = $np-head/@id) and tb:descends-directly-or-solely-via-coordinators(parent::word, $np-head)">
        <xsl:value-of select="$adnominal-genitive-number"/>
      </xsl:when>
      <!-- Temporary error-catching code (for articles that by mistake do not agree with their rightfully governing noun) -->
      <xsl:when test="parent::word[tb:is-adjective(.) and parent::word/@id = $np-head/@id]">
        <xsl:value-of select="$error-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-agreeing-member-number"/>
      </xsl:otherwise>       
    </xsl:choose>
    <xsl:text>art</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="word[@relation='AuxC']" mode="span-pattern tree-pattern" priority="100">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-declinable-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>sub</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="word[tb:is-coordinator(.)]" mode="span-pattern tree-pattern" priority="1">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-declinable-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>coord</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

<!-- Here the order of the whens is different than in the other templates,
    since I assume that the genitive case of a modifying noun in the NP
    should take precedence over its (sometimes incidental) agreement 
    with the np-head -->
  <xsl:template match="word[tb:is-noun(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="@id = $np-head/@id">
        <xsl:value-of select="$head-number"/>
      </xsl:when>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>     
      <xsl:when test="tb:is-genitive(.) and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:value-of select="$adnominal-genitive-number"/>
      </xsl:when>
      <xsl:when test="tb:agrees(., $np-head)">
        <xsl:value-of select="$agreeing-member-number"/>
      </xsl:when>      
      <xsl:otherwise>
        <xsl:value-of select="$non-agreeing-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>noun</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-numeral(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="@id = $np-head/@id">
        <xsl:value-of select="$head-number"/>
      </xsl:when>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>      
      <xsl:when test="tb:agrees(., $np-head)">
        <xsl:value-of select="$agreeing-member-number"/>
      </xsl:when>
      <xsl:when test="tb:is-genitive(.) and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:value-of select="$adnominal-genitive-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-agreeing-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>num</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-particle(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-declinable-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>particle</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-participle(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="@id = $np-head/@id">
        <xsl:value-of select="$head-number"/>
      </xsl:when>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>      
      <xsl:when test="tb:agrees(., $np-head)">
        <xsl:value-of select="$agreeing-member-number"/>
      </xsl:when>
      <xsl:when test="tb:is-genitive(.) and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:value-of select="$adnominal-genitive-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-agreeing-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>part</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-preposition(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-declinable-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>prep</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="word[tb:is-pronoun(.)]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="@id = $np-head/@id">
        <xsl:value-of select="$head-number"/>
      </xsl:when>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>      
      <xsl:when test="tb:agrees(., $np-head)">
        <xsl:value-of select="$agreeing-member-number"/>
      </xsl:when>
      <xsl:when test="tb:is-genitive(.) and tb:descends-directly-or-solely-via-coordinators(., $np-head)">
        <xsl:value-of select="$adnominal-genitive-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$non-agreeing-member-number"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>pron</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="word[tb:is-verb(.) and not(tb:is-participle(.))]" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-intruder(., $np-head)">
        <xsl:value-of select="$intruder-number"/>
      </xsl:when>
      <xsl:when test="tb:is-visitor(., $np-head)">
        <xsl:value-of select="$visitor-number"/>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@relation=('ATR', 'ATR_CO')">
        <xsl:text>acl</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>verb</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="word[tb:is-punctuation(.)]" mode="span-pattern tree-pattern"/>
  
  <!-- Catch-all template for any word that doesn't have a special template -->
  <xsl:template match="word" mode="span-pattern tree-pattern">
    <xsl:param name="include-form" select="false()"/>
    <xsl:value-of select="$unknown-pos-number"/>
    <xsl:text>unknown</xsl:text>
    <xsl:if test="$include-form">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@form"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>  

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Return the supplied $input-tokens with all sequences of
       consecutive identical elements collapsed into a single
       instance. E.g. ("1noun" "2adj" "2adj" "4part" "2adj") becomes
       ("1noun" "2adj" "4part" "2adj") -->
  <xsl:function name="tb:consolidate-tokens" as="xs:string*">
    <xsl:param name="input-tokens"/>
    <xsl:param name="output-tokens"/>
    <xsl:variable name="new-input-tokens" select="remove($input-tokens, 1)"/>
    <xsl:choose>
      <xsl:when test="count($input-tokens) = 0">
        <xsl:sequence select="$output-tokens"/>
      </xsl:when>      
      <xsl:when test="$input-tokens[1] = $output-tokens[last()]">
        <xsl:sequence select="tb:consolidate-tokens($new-input-tokens, $output-tokens)"/>
      </xsl:when>
      <!-- Never include certain tokens in the simple pattern: -->
      <xsl:when test="$input-tokens[1] = ('4coord', '4particle')">
        <xsl:sequence select="tb:consolidate-tokens($new-input-tokens, $output-tokens)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="tb:consolidate-tokens($new-input-tokens, ($output-tokens, $input-tokens[1]))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-in-np" as="xs:boolean">
    <!-- Be aware that this function does not consider the np-head to
         be part of the noun phrase. -->
    <xsl:param name="current-word"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="contains($current-word/@np-heads, concat(' ', $np-head/@id, ' '))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-intruder" as="xs:boolean">
    <xsl:param name="current-word"/>
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="tb:is-in-np($current-word, $np-head)">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="not($np-head/@id = $current-word/ancestor::word/@id)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="tb:is-visitor" as="xs:boolean">
    <!-- Note! This does not check that $current-word is a descendant
         of the np-head, and therefore any intruder will be marked as
         a visitor under this code. Therefore, check for intruders
         before using this function! -->
    <xsl:param name="current-word"/>
    <xsl:param name="np-head"/>
    <xsl:variable name="is-in-np" select="tb:is-in-np($current-word, $np-head)"/>
    <xsl:choose>
      <!-- When a preposition introduces a noun phrase, it is
           annotated as @visitor-head='true'. Without this first
           check, for the case when the current word is in the noun
           phrase and an ancestor of the head, such a preposition
           would be improperly marked as a visitor. -->
      <xsl:when test="$is-in-np and $np-head/@id = $current-word//word/@id">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="$current-word/@visitor-head='true'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="not($is-in-np)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

<!-- Remove starting and ending tokens causing discontinuity (cause they're not!)
    from the supplied tokens in the span pattern -->
  <xsl:function name="tb:trim-edges" as="xs:string*">
    <xsl:param name="input-tokens"/>
    <xsl:param name="edge"/>
    <xsl:variable name="edge-token">
      <xsl:choose>
        <xsl:when test="$edge = 'left'">
          <xsl:value-of select="$input-tokens[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$input-tokens[last()]"/><!-- last token -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="edge-position">
      <xsl:choose>
        <xsl:when test="$edge = 'left'">
          <xsl:value-of select="1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count($input-tokens)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($edge-token, string($intruder-number))">
        <xsl:sequence select="tb:trim-edges(remove($input-tokens, $edge-position), $edge)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$input-tokens"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:include href="utils.xsl"/>
  
  <!-- Path to treebank file being indexed -->
  <xsl:param name="file-path"/>
  
  <xsl:template match="/">
    <xsl:variable name="text-facets">
      <xsl:call-template name="index-text-facets"/>
      <xsl:call-template name="language-proficiency"/>
    </xsl:variable>
    <add>
      <doc>
        <field name="file_path">
          <xsl:value-of select="$file-path"/>
        </field>
        <field name="document_type">text</field>        
        <!-- Source corpus, genre, date, author, title  -->
        <xsl:copy-of select="$text-facets"/>
        <xsl:call-template name="index-text-tags"/>        
        <xsl:apply-templates select="/aggregation/treebank/sentences/@n" mode="text-sentences"/>
        <xsl:apply-templates select="/aggregation/treebank/sentences" mode="text-tokens"/>
      </doc>
      <xsl:apply-templates select="/aggregation/treebank/sentences/sentence" mode="word">
        <xsl:with-param name="text-facets" select="$text-facets"/>
      </xsl:apply-templates>
    </add>
  </xsl:template>
  
  <xsl:template match="centuries" mode="corpus-tag">
    <xsl:for-each select="tokenize(@n, '\s+')">
      <xsl:if test=". != '0'">
        <field name="corpus_tags">
          <xsl:value-of select="tb:get-century(.)"/>
        </field>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="@* | *" mode="corpus-tag">
    <xsl:if test="normalize-space(.)">
      <field name="corpus_tags">
        <xsl:value-of select="."/>
      </field>
    </xsl:if>
  </xsl:template>    
  
  <xsl:template match="centuries" mode="text-century">
    <xsl:variable name="centuries" select="tokenize(@n, '\s+')"/>
    <xsl:for-each select="$centuries">
      <xsl:if test=". != '0'">
        <field name="text_century">
          <xsl:value-of select="tb:get-century(.)"/>
        </field>
      </xsl:if>
    </xsl:for-each>
    <!-- To avoid problems with texts being dated in multiple centuries
    and inflating the overall number of documents, we are adding the 
    possibility to choose earliest or latest century. This is ignoring 
    texts that have been annotated as spanning more than 2 centuries. -->
    <xsl:variable name="earliest-century" select="$centuries[1]"/>
    <xsl:variable name="latest-century" select="$centuries[last()]"/>
    <xsl:variable name="difference" select="xs:integer($latest-century) - xs:integer($earliest-century)"/>
    <xsl:choose>      
      <xsl:when test="$difference &lt; 2 or ($difference = 2 and $earliest-century = '-1')">
        <field name="text_century_earliest">
          <xsl:value-of select="tb:get-century($earliest-century)"/>
        </field>
        <field name="text_century_latest">
          <xsl:value-of select="tb:get-century($latest-century)"/>
        </field>
        <field name="text_century_minimal_range">
          <xsl:value-of select="true()"/>
        </field>
      </xsl:when>
      <xsl:otherwise>
        <field name="text_century_minimal_range">
          <xsl:value-of select="false()"/>
        </field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="author" mode="text-author">
    <field name="text_author">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="genre" mode="text-genre">
    <field name="text_genre">
      <xsl:value-of select="."/>
    </field>
    <xsl:if test="genre = ('Epic', 'Hymn', 'Poetry', 'Tragedy')">
      <field name="text_verse_type">
        <xsl:choose>
          <xsl:when test=". = 'Tragedy'">
            <xsl:text>Tragedy</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Not tragedy</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </field>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="genre" mode="text-language-type">
    <xsl:choose>
      <xsl:when test="normalize-space(.) = ('Dream', 'Letter', 'Memorandum (private)',
        'Memorandum (official)', 'Uncertain')">
        <field name="text_language_type">
          <xsl:text>Private</xsl:text>
        </field>
      </xsl:when>
      <xsl:when test="normalize-space(.) = ('Account', 'contract', 'Declaration', 'Declaration (apographè)', 
        'List', 'Mixed', 'Notice', 'Notification', 'Offer', 'Order', 'Receipt', 'Registration', 
        'Report')">
        <field name="text_language_type">
          <xsl:text>Administration</xsl:text>
        </field>
      </xsl:when>
      <xsl:when test="normalize-space(.) = ('Petition', 'Response (official - ypographè)')">
        <field name="text_language_type">
          <xsl:text>Petition</xsl:text>
        </field>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="treebank/keywords/keyword" mode="text-keyword">
    <field name="text_keyword">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="treebank/@corpus" mode="text-corpus">
    <field name="text_corpus">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="treebank/@text" mode="text-name">
    <field name="text_name">
      <xsl:value-of select="."/>
    </field>
  </xsl:template> 
  
  <xsl:template match="sentences/@n" mode="text-sentences">
    <field name="text_sentences">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="sentences" mode="text-tokens">
    <field name="text_tokens">
      <xsl:value-of select="@token-count-actual"/>
    </field>
    <field name="text_tokens_all">
      <xsl:value-of select="@token-count-all"/>
    </field>
    <field name="text_tokens_gap">
      <xsl:value-of select="@token-count-gap"/>
    </field>
    <field name="text_tokens_punctuation">
      <xsl:value-of select="@token-count-punctuation"/>
    </field>
    <field name="text_tokens_artificial">
      <xsl:value-of select="@token-count-artificial"/>
    </field>
  </xsl:template>
  
  <xsl:template match="sentence" mode="word">
    <xsl:param name="text-facets"/>
    <xsl:variable name="serialized-sentence">
      <xsl:apply-templates select=".//word" mode="serialize">
        <xsl:sort select="xs:integer(@id)"></xsl:sort>
      </xsl:apply-templates>
    </xsl:variable>
    <doc>
      <field name="file_path">
        <xsl:value-of select="$file-path"/>
      </field>
      <field name="document_type">sentence</field>
      <xsl:copy-of select="$text-facets"/>
      <field name="w_sentence_id">
        <xsl:value-of select="@id"/>
      </field>
      <field name="w_sentence_text">
        <xsl:value-of select="$serialized-sentence"/>
      </field>   
      <xsl:for-each select="tokenize(@basic-word-order-pattern, '\s+')">
        <field name="sentence_b_w_o_pattern">
          <xsl:value-of select="."/>
        </field>
      </xsl:for-each>
      <xsl:variable name="multiple-sentence-constituents" as="xs:string*">
        <xsl:for-each select="tokenize(@basic-word-order-pattern, '\s+')">
          <xsl:if test=". != 'V'">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="not(empty($multiple-sentence-constituents))">
          <field name="sentence_verb_final">
            <xsl:variable name="has-verb-final-pattern" as="xs:string*">
              <xsl:for-each select="tokenize(@basic-word-order-pattern, '\s+')">
                <xsl:if test="ends-with(., 'V')">
                  <xsl:text>1</xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="not(empty($has-verb-final-pattern))">
                <xsl:value-of select="true()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="false()"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>        
      </xsl:if>
      <xsl:for-each select="tokenize(@subjects-name, '\s+')">
        <field name="sentence_subject_is_name">
          <xsl:value-of select="."/>
        </field>
      </xsl:for-each>
      <field name="sentence_real_token_count">
        <xsl:value-of select="count(descendant::word[tb:is-real-token(.)])"/>
      </field>
    </doc>
    <xsl:apply-templates select=".//word[tb:is-real-token(.)]" mode="word">
      <xsl:with-param name="serialized-sentence" select="$serialized-sentence"/>
      <xsl:with-param name="text-facets" select="$text-facets"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="word" mode="word">
    <xsl:param name="serialized-sentence"/>
    <xsl:param name="text-facets"/>
    <doc>
      <field name="file_path">
        <xsl:value-of select="$file-path"/>
      </field>
      <field name="document_type">word</field>
      <xsl:copy-of select="$text-facets"/>
      <xsl:if test="normalize-space(@lemma)">
        <field name="w_lemma">
          <xsl:value-of select="@lemma"/>
        </field>
      </xsl:if>
      <field name="w_form">
        <xsl:value-of select="@form"/>
      </field>
      <xsl:choose>
        <xsl:when test="normalize-space(@postag)">
          <field name="w_pos">
            <xsl:call-template name="label-by-pos">
              <xsl:with-param name="pos-code" select="tb:get-pos(.)"/>
            </xsl:call-template>            
          </field>
          <field name="w_person">
            <xsl:value-of select="tb:get-person(.)"/>
          </field>
          <field name="w_number">
            <xsl:choose>
              <xsl:when test="tb:get-number(.) = 's'">
                <xsl:text>singular</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-number(.) = 'p'">
                <xsl:text>plural</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-number(.) = 'd'">
                <xsl:text>dual</xsl:text>
              </xsl:when>
            </xsl:choose>            
          </field>
          <field name="w_tense">
            <xsl:choose>
              <xsl:when test="tb:get-tense(.) = 'a'">
                <xsl:text>aorist</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-tense(.) = 't'">
                <xsl:text>future perfect</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-tense(.) = 'f'">
                <xsl:text>future</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-tense(.) = 'i'">
                <xsl:text>imperfect</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-tense(.) = 'r'">
                <xsl:text>perfect</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-tense(.) = 'l'">
                <xsl:text>plusquamperfect</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-tense(.) = 'p'">
                <xsl:text>present</xsl:text>
              </xsl:when>
            </xsl:choose>            
          </field>
          <field name="w_mood">
            <xsl:choose>
              <xsl:when test="tb:get-mood(.) = 'm'">
                <xsl:text>imperative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 'i'">
                <xsl:text>indicative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 'n'">
                <xsl:text>infinitive</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 'o'">
                <xsl:text>optative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 'p'">
                <xsl:text>participle</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 's'">
                <xsl:text>subjunctive</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 'g'">
                <xsl:text>gerundive</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-mood(.) = 'd'">
                <xsl:text>gerund</xsl:text>
              </xsl:when>
            </xsl:choose>
          </field>
          <field name="w_voice">
            <xsl:choose>
              <xsl:when test="tb:get-voice(.) = 'a'">
                <xsl:text>active</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-voice(.) = 'e'">
                <xsl:text>medio-passive</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-voice(.) = 'm'">
                <xsl:text>middle</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-voice(.) = 'p'">
                <xsl:text>passive</xsl:text>
              </xsl:when>
            </xsl:choose>
          </field>
          <field name="w_gender">
            <xsl:choose>
              <xsl:when test="tb:get-gender(.) = 'f'">
                <xsl:text>feminine</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-gender(.) = 'm'">
                <xsl:text>masculine</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-gender(.) = 'n'">
                <xsl:text>neuter</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>undefined</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="w_case">
            <xsl:choose>
              <xsl:when test="tb:get-case(.) = 'a'">
                <xsl:text>accusative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-case(.) = 'd'">
                <xsl:text>dative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-case(.) = 'g'">
                <xsl:text>genitive</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-case(.) = 'n'">
                <xsl:text>nominative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-case(.) = 'v'">
                <xsl:text>vocative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-case(.) = 'b'">
                <xsl:text>ablative</xsl:text>
              </xsl:when>
            </xsl:choose>
          </field>
          <field name="w_degree">
            <xsl:choose>
              <xsl:when test="tb:get-degree(.) = 'c'">
                <xsl:text>comparative</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-degree(.) = 'p'">
                <xsl:text>positive</xsl:text>
              </xsl:when>
              <xsl:when test="tb:get-degree(.) = 's'">
                <xsl:text>superlative</xsl:text>
              </xsl:when>
            </xsl:choose>
          </field>
          <field name="w_agrees_with_governor">
            <xsl:value-of select="tb:agrees(., tb:get-governing-substantive(.))"/>
          </field>
        </xsl:when>
        <xsl:otherwise>
          <field name="w_pos">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_person">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_number">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_tense">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_mood">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_voice">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_gender">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_case">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_degree">
            <xsl:text>[no @postag]</xsl:text>
          </field>
          <field name="w_agrees_with_governor">
            <xsl:text>[no @postag]</xsl:text>
          </field>
        </xsl:otherwise>
      </xsl:choose>
      <field name="w_sentence_id_string">
        <xsl:value-of select="ancestor::sentence/@id"/>
      </field>
      <field name="w_sentence_id">
        <xsl:value-of select="ancestor::sentence/@id"/>
      </field>
      <field name="w_id">
        <xsl:value-of select="@id"/>
      </field>
      <field name="w_relation">
        <xsl:choose>
          <xsl:when test="@relation=''">
            <xsl:text>nil</xsl:text>
          </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@relation"/> 
        </xsl:otherwise>
        </xsl:choose>
      </field>
      <field name="w_is_attributive">
        <xsl:value-of select="tb:is-attributive(.)"/>            
      </field>
      <field name="w_sentence_text">
        <xsl:value-of select="$serialized-sentence"/>
      </field>      
      <xsl:variable name="parent" select="parent::word"/>
      <xsl:variable name="non_coordinator_first_ancestor" select="ancestor::word[not(tb:is-coordinator(.))][1]"/>
      <field name="w_first_governor_pos" >            
        <xsl:choose>
          <xsl:when test="$parent[normalize-space(@postag)]">
            <xsl:value-of select="tb:get-pos($parent)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[no @postag]</xsl:text>
          </xsl:otherwise>
        </xsl:choose>             
      </field>
      <field name="w_first_governor_is_root">
        <xsl:choose>
          <xsl:when test="not($parent)">
            <xsl:text>true</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>false</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </field>
      <field name="w_first_governor_relation">    
        <xsl:choose>
          <xsl:when test="$parent[normalize-space(@relation)]">
            <xsl:value-of select="tb:get-relation($parent)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[no @relation]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      
      <!-- First non-conjunction governor -->
      <xsl:if test="$non_coordinator_first_ancestor/@ag-modifiers">
        <field name="w_first_head_other_modifiers">
          <xsl:value-of select="tb:get-other-np-modifiers($non_coordinator_first_ancestor)"/>
        </field>
      </xsl:if>
      <field name="w_first_head_lemma">
        <xsl:value-of select="$non_coordinator_first_ancestor/@lemma"/>                    
      </field>
      <field name="w_first_head_pos">   
        <xsl:choose>
          <xsl:when test="$non_coordinator_first_ancestor[normalize-space(@postag)]">
            <xsl:value-of select="tb:get-pos($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[no @postag]</xsl:text>
          </xsl:otherwise>
        </xsl:choose>            
      </field>
      <field name="w_first_head_relation">   
        <xsl:choose>
          <xsl:when test="$non_coordinator_first_ancestor[normalize-space(@relation)]">
            <xsl:value-of select="tb:get-relation($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[no @relation]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_mood">   
        <xsl:choose>
          <xsl:when test="tb:is-verb($non_coordinator_first_ancestor)">
            <xsl:value-of select="tb:get-mood($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[unknown mood]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_tense">   
        <xsl:choose>
          <xsl:when test="tb:is-verb($non_coordinator_first_ancestor)">
            <xsl:value-of select="tb:get-tense($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[unknown tense]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_animacy">   
        <xsl:choose>
          <xsl:when test="$non_coordinator_first_ancestor[normalize-space(@animacy)]">
            <xsl:value-of select="$non_coordinator_first_ancestor/@animacy"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[no @animacy]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_case">   
        <xsl:choose>
          <xsl:when test="$non_coordinator_first_ancestor[normalize-space(@postag)]">
            <xsl:value-of select="tb:get-case($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[unknown]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_gender">   
        <xsl:choose>
          <xsl:when test="$non_coordinator_first_ancestor[normalize-space(@postag)]">
            <xsl:value-of select="tb:get-gender($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[unknown]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_number">   
        <xsl:choose>
          <xsl:when test="$non_coordinator_first_ancestor[normalize-space(@postag)]">
            <xsl:value-of select="tb:get-number($non_coordinator_first_ancestor)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[unknown]</xsl:text>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_has_article">   
        <xsl:choose>
          <xsl:when test="tb:has-article($non_coordinator_first_ancestor)">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
          </xsl:otherwise>
        </xsl:choose> 
      </field>
      <field name="w_first_head_is_name">
        <xsl:value-of select="tb:is-name(ancestor::word[not(tb:is-coordinator(.))][1])"/>
      </field> 
      <!-- First dependent -->
      <xsl:for-each select="word">
        <field name="w_first_level_dependent_lemma">
          <xsl:value-of select="@lemma"/> 
        </field>
        <field name="w_first_level_dependent_relation">
          <xsl:value-of select="tb:get-relation(.)"/> 
        </field>
        <field name="w_first_level_dependent_pos">
          <xsl:value-of select="tb:get-pos(.)"/> 
        </field>
        <field name="w_first_level_dependent_case">
          <xsl:value-of select="tb:get-case(.)"/> 
        </field>
        <field name="w_first_level_dependent_mood">
          <xsl:value-of select="tb:get-mood(.)"/> 
        </field>
        <field name="w_first_level_dependent_tense">
          <xsl:value-of select="tb:get-tense(.)"/> 
        </field>
        <field name="w_first_level_dependent_number">
          <xsl:value-of select="tb:get-number(.)"/> 
        </field>
        <field name="w_first_level_dependent_person">
          <xsl:value-of select="tb:get-person(.)"/> 
        </field>
        <field name="w_first_level_dependent_gender">
          <xsl:value-of select="tb:get-gender(.)"/> 
        </field>
      </xsl:for-each>      
      <field name="w_is_proper_name">
        <xsl:choose>
          <xsl:when test="tb:is-name(.)">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
          </xsl:otherwise>
        </xsl:choose>
      </field>
      <xsl:if test="normalize-space(@animacy)">
        <field name="w_animacy">
          <xsl:value-of select="@animacy"/>
        </field>
      </xsl:if>
      <field name="w_has_article">
        <xsl:choose>
          <xsl:when test="tb:has-article(.)">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
          </xsl:otherwise>
        </xsl:choose>
      </field>
      <field name="w_is_next_to_governor">
        <xsl:value-of select="tb:words-are-continguous($non_coordinator_first_ancestor, .)"/>
      </field>
      <xsl:for-each select="word[tb:is-article(.)]">
        <field name="w_article_case">
          <xsl:value-of select="tb:get-case(.)"/> 
        </field>
      </xsl:for-each>
      <xsl:if test="@position-in-np">
        <field name="w_position_in_np_full">
          <xsl:choose>
            <xsl:when test="@position-in-np = 'internal'">
              <xsl:text>internal</xsl:text>
            </xsl:when>
            <!-- I haven't been able to find a single proper preposed-ds
              instance with either adjectives or ags, but I am getting 
              *a lot* of false-positives. Therefore, I am temporarily disabling the 
              option of indexing things as preposed-ds and all instances 
              of modifiers before the noun will be indexed as preposed.-->
            <xsl:when test="contains(@position-in-np,'preposed')">
              <xsl:text>preposed</xsl:text>
            </xsl:when>
            <xsl:when test="contains(@position-in-np,'postposed')">
              <xsl:choose>
                <xsl:when test="tb:get-governing-substantive(.)/@is-ds='true'">
                  <xsl:text>postposed-DS</xsl:text>
                </xsl:when>
                <xsl:when test="tb:get-governing-substantive(.)/@is-ds='false'">
                  <xsl:text>postposed</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </field>
        <field name="w_position_in_np">
          <xsl:choose>
            <xsl:when test="@position-in-np = 'preposed-ds'">
              <xsl:text>preposed</xsl:text>
            </xsl:when>
            <xsl:when test="@position-in-np = 'postposed-ds'">
              <xsl:text>postposed</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@position-in-np"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </xsl:if>
      <xsl:if test="@governing-substantive">
        <field name="w_is_in_hyperbaton">
          <xsl:value-of select="true()"/>
        </field>
      </xsl:if>
      <!-- QAZ, NB etc. - pay attention, future Polina! Currently this is only set up to 
        work for the adnominal genitive chapter; needs tweaking in the future! -->
    </doc>
  </xsl:template>
  
  <xsl:template match="word" mode="serialize">
    <xsl:value-of select="@form"/>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template name="get-century">
    <xsl:choose>
      <xsl:when test="starts-with(., '-')">
        <xsl:value-of select="substring-after(., '-')"/>
        <xsl:text>bc</xsl:text>
      </xsl:when>
      <xsl:when test="not(normalize-space())">
        <xsl:text>unknown</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
        <xsl:text>ad</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="tb:get-century">
    <xsl:param name="century-number"/>
    <xsl:choose>
      <xsl:when test="starts-with($century-number, '-')">
        <xsl:value-of select="substring-after($century-number, '-')"/>
        <xsl:text>bc</xsl:text>
      </xsl:when>
      <xsl:when test="not(normalize-space($century-number))">
        <xsl:text>unknown</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$century-number"/>
        <xsl:text>ad</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template name="index-text-facets">
    <xsl:apply-templates select="/aggregation/treebank/metadata/date/centuries" mode="text-century"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/author" mode="text-author"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/genres/genre" mode="text-genre"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/genres/genre" mode="text-language-type"/>
    <xsl:apply-templates select="/aggregation/treebank/@corpus" mode="text-corpus"/>
    <xsl:apply-templates select="/aggregation/treebank/@text" mode="text-name"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/keywords/keyword" mode="text-keyword"/>
  </xsl:template>
  
  <xsl:template name="index-text-tags">    
    <xsl:apply-templates select="/aggregation/treebank/@corpus" mode="corpus-tag"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/genres/genre" mode="corpus-tag"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/date/centuries" mode="corpus-tag"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/language_proficiency/@label" mode="corpus-tag"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/author" mode="corpus-tag"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/title" mode="corpus-tag"/>
    <xsl:apply-templates select="/aggregation/treebank/metadata/keywords/keyword" mode="corpus-tag"/>
  </xsl:template>
  
  <xsl:template name="language-proficiency">
    <field name="text_language_proficiency">
      <xsl:value-of select="/aggregation/treebank/metadata/language_proficiency/@label"/>
    </field>
  </xsl:template>
  
  <!-- This function returns the type of modifiers (other than the ag) to the supplied np-head -->
  <xsl:function name="tb:get-other-np-modifiers" as="xs:string">
    <xsl:param name="np-head"/>
    <xsl:choose>
      <xsl:when test="$np-head/@adjectival-modifiers
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@participial-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@pronominal-modifiers)">
        <xsl:text>adjective</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@demonstrative-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@participial-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@pronominal-modifiers)">
        <xsl:text>demonstrative</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@participial-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@pronominal-modifiers)">
        <xsl:text>participle</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@quantifier-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@participial-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@pronominal-modifiers)">
        <xsl:text>quantifier</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@nominal-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@participial-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@pronominal-modifiers)">
        <xsl:text>noun</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@numeral-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@participial-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@pronominal-modifiers)">
        <xsl:text>numeral</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@pp-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pronominal-modifiers)
        and not($np-head/@participial-modifiers)">
        <xsl:text>pp</xsl:text>
      </xsl:when>
      <xsl:when test="$np-head/@pronominal-modifiers
        and not($np-head/@adjectival-modifiers)
        and not($np-head/@demonstrative-modifiers)
        and not($np-head/@quantifier-modifiers)
        and not($np-head/@nominal-modifiers)
        and not($np-head/@numeral-modifiers)
        and not($np-head/@pp-modifiers)
        and not($np-head/@participial-modifiers)">
        <xsl:text>pronoun</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>mixed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>

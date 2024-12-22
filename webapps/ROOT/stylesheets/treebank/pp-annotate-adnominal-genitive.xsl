<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet annotates the adnominal genitives -->
  
  <xsl:include href="utils.xsl"/>    
    
  <xsl:template match="/">
    <adnominal-genitives>
      <xsl:attribute name="corpus" select="/aggregation/treebank/@corpus"/>      
      <xsl:attribute name="text" select="/aggregation/treebank/@text"/>
      <xsl:attribute name="genre" select="/aggregation/treebank/metadata/genres/genre"/>
      <xsl:apply-templates select="/aggregation/treebank/sentences/sentence//word[contains(@span-pattern, '8')]"/>      
    </adnominal-genitives>
  </xsl:template>
  
  <xsl:template match="word">
    <instance>
      <xsl:copy-of select="@span-pattern"/>
      <xsl:attribute name="type">
        <xsl:choose>
          <!-- Strict D - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '2art 1[a-z]+ 2art 8art 8') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>D-name</xsl:text>
          </xsl:when>
          <!-- Strict D -->
          <xsl:when test="matches(@span-pattern, '2art 1[a-z]+ 2art 8art 8')">
            <xsl:text>D</xsl:text>
          </xsl:when>
          <!-- D1 - no article to the genitive - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '2art 1[a-z]+ 2art 8(noun|adj)') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>D1-name</xsl:text>
          </xsl:when>
          <!-- D1 - no article to the genitive -->
          <xsl:when test="matches(@span-pattern, '2art 1[a-z]+ 2art 8(noun|adj|pron|part|num)')">
            <xsl:text>D1</xsl:text>
          </xsl:when>
          <!-- D2 - no first article to the np-head - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '1[a-z]+ 2art 8art 8[a-z]') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>D2-name</xsl:text>
          </xsl:when>
          <!-- D2 - no first article to the np-head -->
          <xsl:when test="matches(@span-pattern, '1[a-z]+ 2art 8art 8')">
            <xsl:text>D2</xsl:text>
          </xsl:when>
          <!-- Strict C - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '2art 8art 8[a-z]+ 1[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>C-name</xsl:text>
          </xsl:when>
          <!-- Strict C -->
          <xsl:when test="matches(@span-pattern, '2art 8art 8[a-z]+ 1[a-z]+')">
            <xsl:text>C</xsl:text>
          </xsl:when>
          <!-- C1 - no article to the genitive - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '2art 8[a-z]+ 1[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>C1-name</xsl:text>
          </xsl:when>
          <!-- C1 - no article to the genitive -->
          <xsl:when test="matches(@span-pattern, '2art 8[a-z]+ 1[a-z]+')">
            <xsl:text>C1</xsl:text>
          </xsl:when>
          <!-- Strict A - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '2art 1[a-z]+ 8art 8[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>A-name</xsl:text>
          </xsl:when>
          <!-- Strict A - contiguous tokens -->
          <xsl:when test="matches(@span-pattern, '2art 1[a-z]+ 8art 8[a-z]+')">
            <xsl:text>A</xsl:text>
          </xsl:when>
          <!-- A1 - no article to the genitive - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '2art 1[a-z]+ 8[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>A1-name</xsl:text>
          </xsl:when>
          <!-- A1 - no article to the genitive -->
          <xsl:when test="matches(@span-pattern, '2art 1[a-z]+ 8[a-z]+')">
            <xsl:text>A1</xsl:text>
          </xsl:when>
          <!-- A2 - no article to the np-head - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '1[a-z]+ 8art 8[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>A2-name</xsl:text>
          </xsl:when>
          <!-- A2 - no article to the np-head -->
          <xsl:when test="matches(@span-pattern, '1[a-z]+ 8art 8[a-z]+')">
            <xsl:text>A2</xsl:text>
          </xsl:when>
          <!-- A3 - no article to both - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '1[a-z]+ 8[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>A3-name</xsl:text>
          </xsl:when>
          <!-- A3 - no article to both -->
          <xsl:when test="matches(@span-pattern, '1[a-z]+ 8[a-z]+')">
            <xsl:text>A3</xsl:text>
          </xsl:when>
          <!-- Strict B - contiguous tokens - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '8art 8[a-z]+ 2art 1[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>B-name</xsl:text>
          </xsl:when>
          <!-- Strict B - contiguous tokens -->
          <xsl:when test="matches(@span-pattern, '8art 8[a-z]+ 2art 1[a-z]+')">
            <xsl:text>B</xsl:text>
          </xsl:when>
          <!-- B1 - no article to the genitive -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '8[a-z]+ 2art 1[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>B1-name</xsl:text>
          </xsl:when>
          <!-- B1 - no article to the genitive -->
          <xsl:when test="matches(@span-pattern, '8[a-z]+ 2art 1[a-z]+')">
            <xsl:text>B1</xsl:text>
          </xsl:when>
          <!-- B2 - no article to the np-head - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '8art 8[a-z]+ 1[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>B2-name</xsl:text>
          </xsl:when>
          <!-- B2 - no article to the np-head -->
          <xsl:when test="matches(@span-pattern, '8art 8[a-z]+ 1[a-z]+')">
            <xsl:text>B2</xsl:text>
          </xsl:when>
          <!-- B3 - no article to both - NAME -->
          <xsl:when test="tb:is-name(.) and matches(@span-pattern, '8[a-z]+ 1[a-z]+') and word[tb:is-genitive(.) and tb:is-name(.)]">
            <xsl:text>B3-name</xsl:text>
          </xsl:when>
          <!-- B3 - no article to both -->
          <xsl:when test="matches(@span-pattern, '8[a-z]+ 1[a-z]+')">
            <xsl:text>B3</xsl:text>
          </xsl:when>
          <!-- E - standard dating formula - ἔτους num Καίσαρος -->
          <xsl:when test="@form='ἔτους' and matches(@span-pattern, '1noun 3num 8noun')">
            <xsl:text>E</xsl:text>
          </xsl:when>
          <!-- Unclassified - presubstantive -->
          <xsl:when test="matches(@span-pattern, '8.+1') and not(matches(@span-pattern, '1.+8'))">
            <xsl:text>U-pre</xsl:text>
          </xsl:when>
          <!-- Unclassified - postsubstantive -->
          <xsl:when test="matches(@span-pattern, '1.+8') and not(matches(@span-pattern, '8.+1'))">
            <xsl:text>U-post</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>WHOA</xsl:text>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:attribute>
      <xsl:attribute name="sentence-id" select="ancestor::sentence/@id"/>
    </instance>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet transforms the flat xml structure of the source treebank files into a hierarchical structure which 
    corresponds to the actual dependencies in the trees. Information about date and annotator is omitted here; 
    Sematia info is kept! We have added a sentences element and given it @token-count-all and @token-count-actual. 
    This is useful in later steps when we remove sentences that do not contain any constructions.
  
  NB! As of 19.07.2021, @token-count-actual doesn't have in its number the artificial tokens!
  ... the reason being that I want to see only the number of actual, real words in the papyri.
  
  NB! As of 10.09.2021, we are removing the @head from words, since their purpose is taken over
  by the hierarchical sturcture of the tree. (Jamie made me do it!!!)
  
  Some perseids files have loops in their dependencies, so here we annotate each sentence element with 
  a count of the words in each sentence pre-transformation. -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:param name="corpus"/>
  <xsl:param name="text"/>
  
  <xsl:template match="treebank">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="corpus" select="$corpus"/>
      <xsl:attribute name="text" select="$text"/>
      <xsl:apply-templates select="sematia"/>
      <xsl:apply-templates select="document_meta | hand_meta | text_type"/>
      <xsl:apply-templates select="metadata"/>
      <sentences>
        <xsl:apply-templates select="sentence | comment()"/>
      </sentences>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sentence">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>      
      <xsl:attribute name="word-count">
        <xsl:value-of select="count(word)"/>
      </xsl:attribute>
      <xsl:apply-templates select="word[@head='0' or not(normalize-space(@head))]"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="../word[@head=current()/@id]"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="@head"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

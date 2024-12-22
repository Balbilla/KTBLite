<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- Render a sentence for display as HTML. -->

  <xsl:include href="utils.xsl" />
  <xsl:import href="cocoon://_internal/url/reverse.xsl"/>

  <xsl:template match="sentence">
    <p>      
      <xsl:apply-templates select=".//word" mode="display-word-pos-highlight">
        <xsl:sort select="number(@id)" />
      </xsl:apply-templates>
    </p>
  </xsl:template>

  <xsl:template match="treebank">    
    <div>
      <xsl:apply-templates select="sentences/sentence" />
    </div>
    <div id="sentence-chart"></div>
    <xsl:if test="starts-with(@corpus, 'bgu')">
      <p>This sentence in 
        <xsl:choose>
          <xsl:when test="@corpus='bgu_16_papygreek'">
            <a href="{kiln:url-for-match('sentence', ('bgu_16_leuven', @text, sentences/sentence/@id), 0)}">Leuven</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{kiln:url-for-match('sentence', ('bgu_16_papygreek', @text, sentences/sentence/@id), 0)}">Papygreek</a>
          </xsl:otherwise>
        </xsl:choose>        
      </p>
    </xsl:if>
    <xsl:if test="@corpus='papygreek'">
      <p>This sentence in 
        <a href="{kiln:url-for-match('sentence', ('zleuven', @text, sentences/sentence/@id), 0)}">Duke-nlp</a>
      </p>
    </xsl:if>
    <xsl:if test="@corpus='papygreek_overlap'">
      <p>This sentence in 
        <a href="{kiln:url-for-match('sentence', ('leuven_overlap', @text, sentences/sentence/@id), 0)}">Duke-nlp Overlap</a>
      </p>
    </xsl:if>
    <xsl:if test="@corpus='zleuven'">
      <p>This sentence in 
        <a href="{kiln:url-for-match('sentence', ('papygreek', @text, sentences/sentence/@id), 0)}">PapyGreek</a>          
      </p>      
    </xsl:if>
    <xsl:if test="@corpus='leuven_overlap'">
      <p>This sentence in 
        <a href="{kiln:url-for-match('sentence', ('papygreek_overlap', @text, sentences/sentence/@id), 0)}">PG Overlap</a>
      </p>
    </xsl:if>
    <p>
      <xsl:if test="xs:integer(sentences/sentence/@id) &gt; 1">
        <a href="{kiln:url-for-match('sentence', (@corpus, @text, sentences/sentence/@id - 1), 0)}">Previous</a>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:if test="xs:integer(sentences/sentence/@id) &lt; sentences/@n">
        <a href="{kiln:url-for-match('sentence', (@corpus, @text, sentences/sentence/@id + 1), 0)}">Next</a>
      </xsl:if>
    </p>
    <xsl:if test="sentences[not(sentence)]">
      <xsl:text>No such sentence. </xsl:text>
      <a href="{kiln:url-for-match('sentence', (@corpus, @text, sentences/@n), 0)}">Go to last sentence.</a>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

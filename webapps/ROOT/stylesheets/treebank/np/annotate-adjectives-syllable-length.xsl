<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- "Coordinated" here is taken to mean not only adjectives governed by a coordinator, 
  but also those that are asyndetically linked by a comma or even directly hanging under their
  governing substantive. The reason for this is that treebanking practices are heavily dependent
  on the habits of punctuation employed by the editors, which makes cases which are technically
  in the same class look different if there is a comma involved. In this sense the code is 
  covering both coordinated and uncoordinated adjectives -->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[tb:is-coordinator(.)][count(word[tb:is-adjective(.) and tb:agrees(., tb:get-governing-substantive(.))]) &gt; 1]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="governing-substantive-id" select="tb:get-governing-substantive(.)/@id"/>
      <xsl:if test="$governing-substantive-id">
        <xsl:call-template name="annotate-governor"/>
        <xsl:attribute name="governing-substantive" select="$governing-substantive-id"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-substantive(.)][count(word[tb:is-adjective(.)][tb:agrees(., current())]) &gt; 1]" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-governor"/>      
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[tb:is-adjective(.) and tb:agrees(., tb:get-governing-substantive(.))]">    
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="../word[tb:is-adjective(.)][@id != current()/@id] 
          and parent::word[tb:is-substantive(.) or tb:is-coordinator(.)]">
          <xsl:variable name="governing-substantive" select="tb:get-governing-substantive(.)"/>
            <xsl:attribute name="governor" select="../@id"/>
            <xsl:attribute name="substantive-position">
                <xsl:choose>
                  <xsl:when test="xs:integer(@id) &gt; xs:integer($governing-substantive/@id)">
                    <xsl:text>before</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>after</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:when>       
      </xsl:choose>  
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template name="annotate-governor">
    <xsl:attribute name="is-governor" select="true()"/>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

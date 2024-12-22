<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet deals with the cases where etous
    is incorrectly annotated as the child of a month.
    It moves etous underneath the head word 
    and moves the month, if there is one, to be its sibling. 
    It also fixes their relations. -->
  
  <xsl:include href="../utils.xsl"/>  
   
  <xsl:template match="sentence/word[tb:is-artificial(.) or @form=normalize-unicode('ἔρρωσο')]
    [word[tb:is-month(.)]/word[@form=normalize-unicode('ἔτους')]]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="etous" select="word[tb:is-month(.)]/word[@form=normalize-unicode('ἔτους')][1]"/>
      <xsl:variable name="etous-id" select="xs:integer($etous/@id)"/>
      <xsl:apply-templates select="word[xs:integer(@id) &lt; $etous-id]" mode="no-switch">
        <xsl:with-param name="etous-id" select="$etous-id"/>
      </xsl:apply-templates>      
      <xsl:apply-templates select=".//word[xs:integer(@id) = $etous-id]"/>
      <xsl:apply-templates select="word[xs:integer(@id) &gt; $etous-id]" mode="no-switch">
        <xsl:with-param name="etous-id" select="$etous-id"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word" mode="no-switch">
    <xsl:param name="etous-id"/>
    <xsl:if test="xs:integer(@id) != $etous-id">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="node() | comment()" mode="no-switch">
          <xsl:with-param name="etous-id" select="$etous-id"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- This function only works in the context of dating formulae
    where we do not expect that we might have any other word 
    in the sentence starting with a capital letter. -->
  <xsl:function name="tb:is-month" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="tb:is-name($word) and not($word/@form=normalize-unicode('Καίσαρος'))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>

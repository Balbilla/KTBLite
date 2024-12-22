<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet deals with the cases where etous
    is incorrectly annotated as the child of a Kaisaros.
    It moves etous underneath the head word 
    and moves Kaisaros, if there is one, to be its child. 
    It also fixes their relations. -->
  
  <xsl:include href="../utils.xsl"/>  
   
  <xsl:template match="sentence/word[tb:is-artificial(.) or @form=normalize-unicode('ἔρρωσο')]
    [word[@form=normalize-unicode('Καίσαρος')]/word[@form=normalize-unicode('ἔτους')]]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="etous" select="word[@form=normalize-unicode('Καίσαρος')]/word[@form=normalize-unicode('ἔτους')]"/>
      <xsl:variable name="etous-id" select="xs:integer($etous/@id)"/>
      <xsl:variable name="kaisaros-id" select="number($etous/../@id)"/>
      <xsl:apply-templates select="word[xs:integer(@id) &lt; $etous-id]" mode="no-switch">
        <xsl:with-param name="kaisaros-id" select="$kaisaros-id"/>
      </xsl:apply-templates>
      <xsl:apply-templates select=".//word[xs:integer(@id) = $etous-id]" mode="switch"/>
      <xsl:apply-templates select="word[xs:integer(@id) &gt; $etous-id]" mode="no-switch">
        <xsl:with-param name="kaisaros-id" select="$kaisaros-id"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word[@form=normalize-unicode('ἔτους')]" mode="switch">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>            
      <!-- We are making the assumption that all of the children of etous (usually 
        just the numeral) come before the Kaisaros. -->
      <xsl:apply-templates select="node()"/>
      <xsl:apply-templates select="parent::word" mode="switch"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word" mode="switch">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="word" mode="no-switch">
    <xsl:param name="kaisaros-id"/>
    <xsl:choose>
      <xsl:when test="number(@id) = $kaisaros-id">
        <xsl:apply-templates select="word[@form!=normalize-unicode('ἔτους')]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@* | node() | comment()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
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

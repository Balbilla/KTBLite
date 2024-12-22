<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates words participating in genitive absolute construction with @group 
  whose value groups all words in the same construction; the value is the @id of the first agent. -->
  
  <!-- We start at a genitive subject and in order to tell whether it's participating in a GA we look for a genitive participle, which can occur on various places in the tree, so we must
  define the valid paths towards that participle from the agent. Coordinators make things tricky!-->
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:template match="word[tb:is-genitive(.) and tb:is-subject(.)]" priority="100">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="has-participle">
        <!-- Here we only need to look for parents cause we can't have agents having children participles ever -->
        <xsl:apply-templates select="parent::word" mode="to-participle">
          <xsl:with-param name="source-word-id" select="@id"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:if test="normalize-space($has-participle)"><!-- XSLT magic needed here! This tests for a valid path to a participle -->
        <!-- This variable will contain not a single string, but a list of strings -->
        <xsl:variable name="agent-ids" as="xs:integer*">
          <xsl:apply-templates select="parent::word" mode="to-agent"/>
          <xsl:sequence select="@id"/>
        </xsl:variable>
        <xsl:call-template name="add-group-attribute">
          <!-- This gets the smallest values out of the list of agent ids: -->
          <xsl:with-param name="id" select="min($agent-ids)"/>
        </xsl:call-template>
        <xsl:attribute name="is-agent" select="true()"/>
        </xsl:if>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
   
  <xsl:template match="word[tb:is-participle(.) and tb:is-genitive(.) and tb:has-valid-ancestry(.)]"><!-- valid ancestry defined below -->
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- In order to avoid a participle getting mixed up in another group when it has an agent as a child,
      first check the children and only look to the parent if there are no subject children. -->
      <xsl:variable name="child-agent-ids" as="xs:integer*">
        <xsl:apply-templates select="word" mode="to-agent">
          <xsl:with-param name="source-word-id" select="@id"/>
        </xsl:apply-templates>        
      </xsl:variable>
      <!-- Encompassing also fragmentary sentences where gen absol aren't attached to the tree at all -->
      <xsl:choose>
        <xsl:when test="$child-agent-ids[1]">
            <xsl:call-template name="add-group-attribute">
            <xsl:with-param name="id" select="min($child-agent-ids)"/>
          </xsl:call-template>
          <xsl:attribute name="is-participle" select="true()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="parent-agent-ids" as="xs:integer*">
            <xsl:apply-templates select="parent::word" mode="to-agent">
              <xsl:with-param name="source-word-id" select="@id"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:if test="$parent-agent-ids[1]">
            <xsl:call-template name="add-group-attribute">
              <xsl:with-param name="id" select="min($parent-agent-ids)"/>
            </xsl:call-template>
            <xsl:attribute name="is-participle" select="true()"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="word[tb:is-genitive(.) and tb:is-subject(.)]" mode="to-agent" priority="100">
    <!-- value-of only gets the value; sequence creates a list of the values -->
    <xsl:sequence select="xs:integer(@id)"/>
  </xsl:template>
  
  <xsl:template match="word[tb:is-coordinator(.)]" mode="to-agent">
    <xsl:param name="source-word-id"/><!-- needed so we don't bounce between coords that are in dependency -->
    <!-- for type 2 -->
    <xsl:apply-templates select="parent::word[@id!=$source-word-id]" mode="to-agent">
      <xsl:with-param name="source-word-id" select="@id"/>
    </xsl:apply-templates>
    <!-- for types 3 and 4 -->
    <!-- If the coordinator has only coord children, then it is not participating in the construction but 
      is likely coordinating two separate constructions -->
    <xsl:if test="word[not(tb:is-coordinator(.) or tb:is-auxiliary(.))]">
      <xsl:apply-templates select="word[@id!=$source-word-id]" mode="to-agent">
        <xsl:with-param name="source-word-id" select="@id"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="to-agent"/><!-- everything which is not defined as a valid path to a genitive absolute agent - don't do anything with it -->
  
  <xsl:template match="word[tb:is-participle(.) and tb:is-genitive(.) and tb:has-valid-ancestry(.)]" mode="to-participle">
    <xsl:text>true</xsl:text><!-- this becomes the value of the $has-participle variable; we can then test for whether there's text in the variable (hence the value is arbitrary) and if os -->
  </xsl:template>
  
  <xsl:template match="word[tb:is-coordinator(.)]" mode="to-participle">
    <xsl:param name="source-word-id"/><!-- needed so we don't bounce between coords that are in dependency -->
    <!-- for type 2 -->
    <xsl:apply-templates select="parent::word[@id!=$source-word-id]" mode="to-participle">
      <xsl:with-param name="source-word-id" select="@id"/>
    </xsl:apply-templates>
    <xsl:if test="word[not(tb:is-coordinator(.) or tb:is-auxiliary(.))]">
      <!-- for types 3 and 4 -->
      <xsl:apply-templates select="word[@id!=$source-word-id]" mode="to-participle">
        <xsl:with-param name="source-word-id" select="@id"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*" mode="to-participle"/><!-- everything which is not defined as a valid path to a genitive absolute participle - don't do anything with it -->   
    
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="add-group-attribute">
    <xsl:param name="id"/>
    <xsl:attribute name="group" select="$id"/>
  </xsl:template>
  
  <!-- Figure out why we're doing this!!!! -->
  <xsl:function name="tb:has-valid-ancestry" as="xs:boolean">
    <xsl:param name="participle"/>
    <xsl:variable name="ultimate-governor" select="$participle/ancestor::word[not(@relation=('COORD', 'AuxC'))][1]"/>
    <xsl:choose>
      <!-- Don't not($ultimate-governor) and $participle/@head do the same thing? Check when all tests work properly. -->
      <xsl:when test="tb:is-verb($ultimate-governor) or tb:is-artificial($ultimate-governor) or not($ultimate-governor)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
   
</xsl:stylesheet>

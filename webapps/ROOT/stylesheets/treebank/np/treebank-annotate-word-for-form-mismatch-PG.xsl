<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- This stylesheet annotates the file for form mismatches in
    cases where the postag is the same, in order to spot orthographic
    variation. -->
    
  
  <xsl:include href="../utils.xsl"/>
  
  <xsl:variable name="brackets" select="('(','&lt;' , '}')"/>
  
  <xsl:template match="word[@form != @orig_form]">
    <xsl:copy>
      <xsl:if test="not(contains(@form, '(')) and not(contains(@form, '&lt;')
        and not(contains(@form, '}')))">
        <xsl:attribute name="form-mismatch">
          <xsl:choose>
            <xsl:when test="tb:has-grammatical-mismatch(.)">
              <xsl:text>grammatical</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>orthographical</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>      
      <xsl:apply-templates select="@* | node()"/>      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="tb:has-orthographical-mismatch" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@form != $word/@orig_form">
        <xsl:choose>
          <xsl:when test="tb:has-grammatical-mismatch($word) = true()">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:when test="contains($word/@orig_form, '(')">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:when test="contains($word/@lemma_orig, '&lt;')">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:when test="contains($word/@orig_form, '&lt;')">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:when test="$word/@orig_form = '|extra|'">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="true()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="tb:has-grammatical-mismatch" as="xs:boolean">
    <xsl:param name="word"/>
    <xsl:choose>
      <xsl:when test="$word/@form != $word/@orig_form">
        <xsl:choose>
          <xsl:when test="tb:get-orig-case($word) != tb:get-case($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-case($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:when>
          <xsl:when test="tb:get-orig-gender($word) != tb:get-gender($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-gender($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="tb:get-orig-mood($word) != tb:get-mood($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-mood($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="tb:get-orig-number($word) != tb:get-number($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-number($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="tb:get-orig-person($word) != tb:get-person($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-person($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="tb:get-orig-pos($word) != tb:get-pos($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-pos($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="tb:get-orig-tense($word) != tb:get-tense($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-tense($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="tb:get-orig-voice($word) != tb:get-voice($word)">
            <xsl:choose>
              <xsl:when test="tb:get-orig-voice($word) = ('_', '-')">
                <xsl:value-of select="false()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="true()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- Excluding degree -->
          <xsl:when test="tb:get-orig-degree($word) != tb:get-degree($word)">
            <xsl:value-of select="false()"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>

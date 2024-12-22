<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- Annotates where the accusative object and the subject are
  relative to the verb. Patterns where there are constituents on
  both sides of the verb are omitted. -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="sentence">
    <xsl:copy>
      <xsl:if test="contains(@basic-word-order-pattern, 'A')">
        <xsl:variable name="object-verb-patterns">
          <xsl:for-each select="tokenize(@basic-word-order-pattern, '\s+')">
            <xsl:if test="contains(., 'A')">
              <xsl:choose>
                <xsl:when test="matches(., '^[^A]*V.*A')">
                  <xsl:text>verb_object</xsl:text>
                </xsl:when>
                <xsl:when test="matches(., 'A.*V[^A]*$')">
                  <xsl:text>object_verb</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>both_sides</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:attribute name="object-verb-pattern">
          <xsl:value-of select="normalize-space($object-verb-patterns)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="contains(@basic-word-order-pattern, 'S')">
        <xsl:variable name="subject-verb-patterns">
          <xsl:for-each select="tokenize(@basic-word-order-pattern, '\s+')">
            <xsl:if test="contains(., 'S')">
              <xsl:choose>
                <xsl:when test="matches(., '^[^S]*V.*S')">
                  <xsl:text>verb_subject</xsl:text>
                </xsl:when>
                <xsl:when test="matches(., 'S.*V[^S]*$')">
                  <xsl:text>subject_verb</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>both_sides</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:attribute name="subject-verb-pattern">
          <xsl:value-of select="normalize-space($subject-verb-patterns)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  

</xsl:stylesheet>

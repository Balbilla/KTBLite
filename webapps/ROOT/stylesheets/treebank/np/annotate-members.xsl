<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- This stylesheet annotates all words that are members of a noun
       phrase. It adds an @np-heads attribute giving the @id of all NP
       heads that govern phrases that this word is a member of. Words
       that have a visitor-head between them and an NP head are not
       members of that NP.

       This stylesheet also adds @coordinates-np to words
       co-ordinating noun phrases, with the value being the number of
       noun phrases co-ordinated.

  -->

  <xsl:include href="../utils.xsl"/>

  <xsl:template match="word">
    <xsl:param name="np-heads" select="()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- The np-heads used for this word are:

             * those passed in from its parent;

             * the child or grandchildren with @np-head='true' when this
               word is a preposition introducing a noun phrase;

             * the children with @np-head='true' when this word is a
               co-ordinator of noun phrases introduced by a preposition.
      -->
      <xsl:variable name="current-np-heads" as="xs:string*">
        <xsl:sequence select="$np-heads"/>
        <xsl:choose>
          <xsl:when test=".[tb:is-preposition(.)]/word[@np-head='true']">
            <xsl:sequence select="word[@np-head='true']/@id"/>
          </xsl:when>
          <xsl:when test=".[tb:is-preposition(.)]/word[tb:is-coordinator(.)]/word[@np-head='true']">
            <xsl:sequence select="word[tb:is-coordinator(.)]/word[@np-head='true']/@id"/>
          </xsl:when>
          <xsl:when test=".[tb:is-coordinator(.)][tb:is-preposition(parent::word)]/word[@np-head='true']">
            <xsl:sequence select="word[@np-head='true']/@id"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="exists($current-np-heads) and not(tb:is-punctuation(.))">
        <xsl:attribute name="np-heads">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$current-np-heads"/>
          <xsl:text> </xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="coordinated-nps" select="count(word[@np-head='true'])"/>
      <xsl:if test="tb:is-coordinator(.) and $coordinated-nps &gt; 1">
        <xsl:attribute name="coordinates-np" select="$coordinated-nps"/>
      </xsl:if>
      <xsl:variable name="new-np-heads" as="xs:string*">
        <xsl:if test="not(@visitor-head = 'true')">
          <xsl:sequence select="$np-heads"/>
        </xsl:if>
        <xsl:if test="@np-head = 'true'">
          <xsl:sequence select="@id"/>
        </xsl:if>
      </xsl:variable>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="np-heads" select="$new-np-heads"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

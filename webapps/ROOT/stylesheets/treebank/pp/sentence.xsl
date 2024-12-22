<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Prune a text's treebank down to the single specified sentence,
       and add that sentence's words arranged in a Google
       Charts-suitable format (see
       https://developers.google.com/chart/interactive/docs/datatables_dataviews). -->

  <!-- Number of sentence. -->
  <xsl:param name="sentence" />

  <xsl:include href="../utils.xsl" />

  <xsl:template match="sentence[@id != $sentence]" />

  <xsl:template match="treebank">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()" />
      <chart_data>
        <xsl:text>[
        </xsl:text>
        <xsl:apply-templates mode="chart"
                             select="sentences/sentence[@id=$sentence]" />
        <xsl:text>
        ]</xsl:text>
      </chart_data>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node() | comment()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node() | comment()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="word" mode="chart">
    <xsl:if test="parent::word or preceding-sibling::word">
      <xsl:text>,
      </xsl:text>
    </xsl:if>
    <xsl:text>[{v: '</xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>', f: '&lt;span class="word-relation"&gt;</xsl:text>
    <xsl:value-of select="@relation" />
    <xsl:text>&lt;/span&gt;&lt;br&gt;&lt;span class="word-form word-pos-</xsl:text>
    <xsl:value-of select="tb:get-pos(.)" />
    <xsl:text>"&gt;</xsl:text>
    <xsl:value-of select="@form" />
    <xsl:text>&lt;/span&gt;'}, '</xsl:text>    
    <xsl:value-of select="parent::word/@id"/>
    <xsl:text>', '</xsl:text>
    <xsl:text>word </xsl:text>
    <xsl:value-of select="@id" />
    <xsl:text>; </xsl:text>
    <xsl:value-of select="@postag" />
    <xsl:text>']</xsl:text>
    <xsl:apply-templates mode="chart" select="word" />
  </xsl:template>

</xsl:stylesheet>

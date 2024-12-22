<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform the XML returned from indexing a document in
       Solr. -->

  <xsl:import href="../escape-xml.xsl" />

  <xsl:template match="add" mode="solr">
    <section>
      <h2 class="title is-2">Add new data</h2>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="delete" mode="solr">
    <section>
      <h2 class="title is-2">Remove old data</h2>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="optimize" mode="solr">
    <section>
      <h2 class="title is-2">Optimise the index</h2>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="aggregation/response" mode="solr">
    <xsl:apply-templates mode="solr" />
  </xsl:template>

  <xsl:template match="response" mode="solr">
    <xsl:apply-templates mode="solr" />
    <xsl:variable name="id" select="generate-id(.)" />
    <p class="block">
      <xsl:text>Full XML response: </xsl:text>
    </p>
    <pre id="{$id}">
      <xsl:apply-templates mode="escape-xml" select="." />
    </pre>
  </xsl:template>

  <xsl:template match="responseHeader" mode="solr">
    <xsl:choose>
      <xsl:when test="contains(., 'status=0')">
        <p class="notification is-success">This operation succeeded.</p>
      </xsl:when>
      <xsl:otherwise>
        <p class="notification is-danger">This operation failed.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="kiln:nav" mode="solr" />

</xsl:stylesheet>

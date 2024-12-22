<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="kiln:nav" mode="main-menu">
    <xsl:apply-templates mode="main-menu" />
  </xsl:template>

  <xsl:template match="ul[@type='menu']" mode="main-menu">
    <ul class="uk-navbar-nav">
      <xsl:apply-templates mode="main-menu" />
    </ul>
  </xsl:template>

  <xsl:template match="ul[@type='breadcrumbs']" mode="main-menu" />

  <xsl:template match="a" mode="main-menu">
    <xsl:copy>
      <xsl:call-template name="add-class">
        <xsl:with-param name="class" select="'navbar-item'" />
      </xsl:call-template>
      <xsl:apply-templates mode="main-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="li[ul]/a" mode="main-menu">
    <xsl:copy>
      <xsl:apply-templates mode="main-menu" select="@*" />
      <xsl:call-template name="add-class">
        <xsl:with-param name="class" select="'navbar-link'" />
      </xsl:call-template>
      <xsl:apply-templates mode="main-menu" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="li" mode="main-menu">
    <li>
      <xsl:apply-templates mode="main-menu" select="@* | node()" />
    </li>
  </xsl:template>

  <xsl:template match="li/ul" mode="main-menu">
    <div class="uk-navbar-dropdown">
      <xsl:apply-templates mode="main-menu" />
    </div>
  </xsl:template>

  <!-- For the local menu, display only the siblings of the active
       item. -->
  <xsl:template match="kiln:nav" mode="local-menu">
    <xsl:apply-templates mode="local-menu"
                         select="ul[@type='menu']//ul[li/@class='active']/li" />
  </xsl:template>

  <xsl:template match="li/ul" mode="local-menu" />

  <xsl:template match="ul/@type" mode="main-menu" />
  <xsl:template match="@*|node()" mode="main-menu">
    <xsl:copy>
      <xsl:apply-templates mode="main-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="ul/@type" mode="local-menu" />
  <xsl:template match="@*|node()" mode="local-menu">
    <xsl:copy>
      <xsl:apply-templates mode="local-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="add-class">
    <xsl:param name="class" />
    <xsl:attribute name="class">
      <xsl:if test="@class">
        <xsl:value-of select="@class" />
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:value-of select="$class" />
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>

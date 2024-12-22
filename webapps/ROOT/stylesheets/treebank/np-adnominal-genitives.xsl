<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                exclude-result-prefixes="xs"
                version="2.0">  
    
  <xsl:template name="adnominal-genitives-summary">
    <table class="uk-table uk-table-striped">
      <thead>
        <tr>
          <th>Type</th>
          <th>Count</th>
        </tr>
      </thead>
      <tbody>
       <xsl:for-each-group select="/xincludes/file/adnominal-genitives/instance" group-by="@type">
         <xsl:sort select="current-grouping-key()"/>
         <tr>
           <td><xsl:value-of select="current-grouping-key()"/></td>
           <td><xsl:value-of select="count(current-group())"/></td>
         </tr>
       </xsl:for-each-group>
      </tbody>
    </table>
    
    <table class="uk-table uk-table-striped">
      <thead>
        <tr>
          <th>Genre</th>
          <th>Type</th>
          <th>Count</th>
          <th>Texts</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each-group select="/xincludes/file/adnominal-genitives/instance" group-by="../@genre">
          <xsl:sort select="current-grouping-key()"/>
          <xsl:variable name="genre" select="current-grouping-key()"/>
          <!-- Texts in that genre containing genitive absolutes -->
          <xsl:variable name="number-of-texts" select="count(current-group()/parent::*)"/>
          <xsl:variable name="number-of-types" select="count(distinct-values(current-group()/@type))"/>
          <xsl:for-each-group select="current-group()" group-by="@type">
            <xsl:sort select="current-grouping-key()"/>
            <tr>
              <xsl:if test="position() = 1">
                <td rowspan="{$number-of-types}">
                  <xsl:value-of select="$genre"/>
                  <xsl:text> (</xsl:text>
                  <xsl:value-of select="$number-of-texts"/>
                  <xsl:text> texts containing genitives)</xsl:text>
                </td>
              </xsl:if>
              <td><xsl:value-of select="current-grouping-key()"/></td>
              <td><xsl:value-of select="count(current-group())"/></td>
              <td><xsl:value-of select="count(current-group()/parent::*)"/></td>
            </tr>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </tbody>
    </table>
  </xsl:template>
  
  <xsl:template name="adnominal-genitives-unclassified-instances">
    <h2>Unclassified instances</h2>
    <table class="uk-table uk-table-striped">
      <thead>
        <tr>
          <th>Pattern</th>
          <th>Text</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="/xincludes/file/adnominal-genitives/instance[@type='WHOA']">
          <tr>
            <td><xsl:value-of select="@span-pattern"/></td>
            <td>
              <a href="{kiln:url-for-match('sentence', (../@corpus, ../@text, @sentence-id), 0)}"><xsl:value-of select="../@text"/></a>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
  

</xsl:stylesheet>

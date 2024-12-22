<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:import href="utils.xsl"/>
  
  <xsl:param name="text"/>
  
  <xsl:template match="/">
    <scores text="{$text}">
      <papygreek score="{/aggregation/aggregation[1]/treebank/metadata/language_proficiency/@total-score}">
        <xsl:value-of select="/aggregation/aggregation[1]/treebank/metadata/language_proficiency/@label"/>        
      </papygreek>
      <duke-nlp score="{/aggregation/aggregation[2]/treebank/metadata/language_proficiency/@total-score}">
        <xsl:value-of select="/aggregation/aggregation[2]/treebank/metadata/language_proficiency/@label"/>
      </duke-nlp>
    </scores>
  </xsl:template>
  
</xsl:stylesheet>

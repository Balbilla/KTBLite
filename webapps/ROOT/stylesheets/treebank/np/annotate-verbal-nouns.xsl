<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                exclude-result-prefixes="xs"
                version="2.0">
  
  <!-- This stylesheet annotates verbal nouns that are np-heads. -->
  
  <xsl:include href="../utils.xsl"/>
  
  <!-- Not an exhaustive list! -->
  <xsl:variable name="verbal-noun-suffixes" select="(normalize-unicode('σις'), normalize-unicode('ξις'), normalize-unicode('ψις'), normalize-unicode('εία'), normalize-unicode('εῖα'), 
    normalize-unicode('ευς'), normalize-unicode('εύς'), normalize-unicode('μός'), normalize-unicode('τέος'), normalize-unicode('τήρ'), normalize-unicode('τηρ'), normalize-unicode('της'), 
    normalize-unicode('τής'))" as="xs:string*"/>
  
  <!-- List to be updated continuously; currently contains words from Prose's AG np-heads set -->
  <xsl:variable name="exceptions" select="(normalize-unicode('θυγάτηρ'),normalize-unicode('μήτηρ'), normalize-unicode('νόμος'), 
    normalize-unicode('πατήρ'), normalize-unicode('στρατιώτης'), normalize-unicode('φύσις'), 
    normalize-unicode('ὀχυρότης'), normalize-unicode('χαρακτήρ'), normalize-unicode('ὀφθαλμός'), 
    normalize-unicode('ἰσότης'), normalize-unicode('βωμός'), normalize-unicode('ἰδιότης'), 
    normalize-unicode('λαμπρότης'), normalize-unicode('πολίτης'), normalize-unicode('τραχύτης'), 
    normalize-unicode('ποταμός'), normalize-unicode('οἰκισμός'), normalize-unicode('στρατοπεδεία'), 
    normalize-unicode('δεινότης'), normalize-unicode('οὐλαμός'), normalize-unicode('πολιτεία'), 
    normalize-unicode('κουφότης'), normalize-unicode('τεχνίτης'), normalize-unicode('ἐπιτηδειότης'), 
    normalize-unicode('σεμνότης'), normalize-unicode('θεσμός'), normalize-unicode('φαυλότης'), 
    normalize-unicode('γαστήρ'), normalize-unicode('ἱκέτης'), normalize-unicode('ἁπλότης'), 
    normalize-unicode('κοινότης'), normalize-unicode('οἰκέτης'), normalize-unicode('δυναστεία'), 
    normalize-unicode('ἁγνεία'), normalize-unicode('θηλύτης'), normalize-unicode('ὁσιότης'), 
    normalize-unicode('λεπτότης'), normalize-unicode('ὡραιότης'), normalize-unicode('τρυφερότης'), 
    normalize-unicode('ἰσχνότης'), normalize-unicode('αὐχμός'), normalize-unicode('πραότης'), 
    normalize-unicode('μικρότης'), normalize-unicode('οἰκειότης'), normalize-unicode('καινότης'), 
    normalize-unicode('κρατήρ'), normalize-unicode('ὠμότης'), normalize-unicode('θυμός'), 
    normalize-unicode('δριμύτης'), normalize-unicode('νεοπολίτης'), normalize-unicode('νεότης'), 
    normalize-unicode('κορμός'), normalize-unicode('ἑσμός'), normalize-unicode('θησαυρισμός'), 
    normalize-unicode('ὁμαλότης'), normalize-unicode('ἀνισότης'), normalize-unicode('ἀριθμός'),
    normalize-unicode('βαρύτης'), normalize-unicode('ὁμοιότης'), normalize-unicode('συμπολιτεία'), 
    normalize-unicode('ὀξύτης'), normalize-unicode('στενότης'), normalize-unicode('κυριεία'), 
    normalize-unicode('ἐπιδεξιότης'), normalize-unicode('ἐφεδρεία'), normalize-unicode('ὀλιγότης'))"/>
  
  <xsl:template match="word[@np-head='true' and tb:is-noun(.) and not(tb:is-name(.))]">
    <xsl:copy>
      <xsl:variable name="lemma" select="normalize-space(@lemma)"/>
      <xsl:variable name="is-verbal-noun">
        <xsl:for-each select="$verbal-noun-suffixes">
          <xsl:if test="ends-with($lemma, .) and not($lemma=$exceptions)">
            <xsl:value-of select="true()"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>      
      <xsl:if test="$is-verbal-noun='true'">
        <xsl:attribute name="verbal-noun" select="true()"/>
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

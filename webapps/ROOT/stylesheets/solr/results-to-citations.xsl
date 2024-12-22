<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="cocoon://_internal/url/reverse.xsl" />
  
  <xsl:template match="/">
    <p>
      <xsl:for-each-group select="response/result/doc" group-by="str[@name='text_name']">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:choose>  
          <!-- Aeschines -->
          <xsl:when test="current-grouping-key() = 'Aeschines_1'">
            <xsl:text>Aeschin. 1</xsl:text>
          </xsl:when>  
          <!-- Aeschylus -->
          <xsl:when test="current-grouping-key() = 'Aesch_Agamemnon'">
            <xsl:text>Aesch. Ag.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aesch_Choeph'">
            <xsl:text>Aesch. Lib.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aesch_Eumenides'">
            <xsl:text>Aesch. Eum.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aesch_Persae'">
            <xsl:text>Aesch. Pers.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aesch_Prometheus'">
            <xsl:text>Aesch. PB</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aesch_Septem'">
            <xsl:text>Aesch. Septem</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aesch_Supplices'">
            <xsl:text>Aesch. Supp.</xsl:text>
          </xsl:when>
          <!-- Aesop -->
          <xsl:when test="current-grouping-key() = 'Aesop'">
            <xsl:text>Aesop</xsl:text>
          </xsl:when>
          <!-- Antiphon -->
          <xsl:when test="current-grouping-key() = 'Antiphon_1'">
            <xsl:text>Antiph. 1</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Antiphon_2'">
            <xsl:text>Antiph. 2</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Antiphon_5'">
            <xsl:text>Antiph. 5</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Antiphon_6'">
            <xsl:text>Antiph. 6</xsl:text>
          </xsl:when>
          <!-- Aphthonius -->
          <xsl:when test="current-grouping-key() = 'Aphthonius_Anaskeue'">
            <xsl:text>Aphth. Prog., An.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Chreia'">
            <xsl:text>Aphth. Prog., Chr.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Diegema'">
            <xsl:text>Aphth. Prog., Dieg.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_EisphoraTouNomou'">
            <xsl:text>Aphth. Prog., Eisph.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Ekphrasis'">
            <xsl:text>Aphth. Prog., Ekphr.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Ethopoiia'">
            <xsl:text>Aphth. Prog., Eth.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Gnome'">
            <xsl:text>Aphth. Prog., Gn.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Kataskeue'">
            <xsl:text>Aphth. Prog., Kat.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_KoinosTopos'">
            <xsl:text>Aphth. Prog., Koin.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Mythos'">
            <xsl:text>Aphth. Prog., Myth.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Psogos'">
            <xsl:text>Aphth. Prog., Ps.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Synkrisis'">
            <xsl:text>Aphth. Prog., Syn.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Aphthonius_Thesis'">
            <xsl:text>Aphth. Prog., Th.</xsl:text>
          </xsl:when>
          <!-- Apollodorus -->
          <xsl:when test="current-grouping-key() = 'Apollodorus_Library'">
            <xsl:text>Apollod.</xsl:text>
          </xsl:when>
          <!-- Appian -->
          <xsl:when test="current-grouping-key() = 'Appian'">
            <xsl:text>App. BC</xsl:text>
          </xsl:when>
          <!-- Aristotle -->
          <xsl:when test="current-grouping-key() = 'Aristotle_Politics'">
            <xsl:text>Aristot. Pol.</xsl:text>
          </xsl:when>
          <!-- Athenaeus -->
          <xsl:when test="current-grouping-key() = 'Athenaeus'">
            <xsl:text>Ath.</xsl:text>
          </xsl:when>
          <!-- Demosthenes -->
          <xsl:when test="current-grouping-key() = 'Demosthenes_1'">
            <xsl:text>Dem. 1</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_4'">
            <xsl:text>Dem. 4</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_18'">
            <xsl:text>Dem. 18</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_27'">
            <xsl:text>Dem. 27</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_41'">
            <xsl:text>Dem. 41</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_42'">
            <xsl:text>Dem. 42</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_46'">
            <xsl:text>Dem. 46</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_47'">
            <xsl:text>Dem. 47</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_49'">
            <xsl:text>Dem. 49</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_50'">
            <xsl:text>Dem. 50</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_52'">
            <xsl:text>Dem. 52</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_53'">
            <xsl:text>Dem. 53</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_57'">
            <xsl:text>Dem. 57</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Demosthenes_59'">
            <xsl:text>Dem. 59</xsl:text>
          </xsl:when>
          <!-- Diodorus -->
          <xsl:when test="current-grouping-key() = 'Diodorus_Sic'">
            <xsl:text>Diod.</xsl:text>
          </xsl:when>
          <!-- Dionysius -->
          <xsl:when test="current-grouping-key() = 'Dionysius_Hal'">
            <xsl:text>D.H.</xsl:text>
          </xsl:when>
          <!-- Herodotus -->
          <xsl:when test="current-grouping-key() = 'Herodotus'">
            <xsl:text>Hdt.</xsl:text>
          </xsl:when>
          <!-- Hesiod -->
          <xsl:when test="current-grouping-key() = 'Hesiod_OD'">
            <xsl:text>Hes. OD.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Hesiod_Theogonia'">
            <xsl:text>Hes. Theog.</xsl:text>
          </xsl:when>
          <!-- Homer -->
          <xsl:when test="current-grouping-key() = 'Homer_Iliad'">
            <xsl:text>Hom. Il.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Homer_Odyssey'">
            <xsl:text>Hom. Od.</xsl:text>
          </xsl:when>
          <!-- Josephus -->
          <xsl:when test="current-grouping-key() = 'Josephus'">
            <xsl:text>J. BJ</xsl:text>
          </xsl:when>
          <!-- Lysias -->
          <xsl:when test="current-grouping-key() = 'Lysias_1'">
            <xsl:text>Lys. 1</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Lysias_12'">
            <xsl:text>Lys. 12</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Lysias_13'">
            <xsl:text>Lys. 13</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Lysias_14'">
            <xsl:text>Lys. 14</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Lysias_15'">
            <xsl:text>Lys. 15</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Lysias_19'">
            <xsl:text>Lys. 19</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Lysias_23'">
            <xsl:text>Lys. 23</xsl:text>
          </xsl:when>
          <!-- Plato -->
          <xsl:when test="current-grouping-key() = 'Plato_Apology'">
            <xsl:text>Plat. Apol.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Plato_Crito'">
            <xsl:text>Plat. Crito</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Plato_Euth'">
            <xsl:text>Plat. Euthyph.</xsl:text>
          </xsl:when>
          <!-- Plutarch -->
          <xsl:when test="current-grouping-key() = 'Plutarch_Alcibiades'">
            <xsl:text>Plut. Alc.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Plutarch_Alexander'">
            <xsl:text>Plut. De Alex.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Plutarch_Fortuna'">
            <xsl:text>Plut. De Fort. Rom.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Plutarch_Lycurgus'">
            <xsl:text>Plut. Lyc.</xsl:text>
          </xsl:when>
          <!-- Polybius -->
          <xsl:when test="current-grouping-key() = 'Polybius'">
            <xsl:text>Plb.</xsl:text>
          </xsl:when>
          <!-- Pseudo-Homer -->
          <xsl:when test="current-grouping-key() = 'PH_Dementer'">
            <xsl:text>HH. 2</xsl:text>
          </xsl:when>
          <!-- Pseudo-Xenophon -->
          <xsl:when test="current-grouping-key() = 'Pseudo_Xenophon'">
            <xsl:text>Ps. Xen. Const. Ath.</xsl:text>
          </xsl:when>
          <!-- Sophocles -->
          <xsl:when test="current-grouping-key() = 'Soph_Ajax'">
            <xsl:text>Soph. Aj.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Soph_Antigone'">
            <xsl:text>Soph. Ant.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Soph_Electra'">
            <xsl:text>Soph. El.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Soph_OT'">
            <xsl:text>Soph. OT</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Soph_Trachinae'">
            <xsl:text>Soph. Trach.</xsl:text>
          </xsl:when>
          <!-- Thucydides -->
          <xsl:when test="current-grouping-key() = 'Thucydides'">
            <xsl:text>Thuc.</xsl:text>
          </xsl:when>
          <!-- Xenophon -->
          <xsl:when test="current-grouping-key() = 'Xenophon_Cyropaedia'">
            <xsl:text>Xen. Cyrop.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Xenophon_Hellenica'">
            <xsl:text>Xen. Hell.</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Xenophon_Hiero'">
            <xsl:text>Xen. Hiero</xsl:text>
          </xsl:when>
          <xsl:when test="current-grouping-key() = 'Xenophon_Symposium'">
            <xsl:text>Xen. Sym.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="current-grouping-key()"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>, s. </xsl:text>
        <xsl:for-each select="current-group()">
          <xsl:sort select="xs:integer(int[@name='w_sentence_id'])"/>
          <a href="{kiln:url-for-match('sentence', (str[@name='text_corpus'], str[@name='text_name'], int[@name='w_sentence_id']), 0)}">
            <xsl:value-of select="int[@name='w_sentence_id']"/>
          </a>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="position() != last()">
            <xsl:text>; </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </p>
  </xsl:template>

</xsl:stylesheet>

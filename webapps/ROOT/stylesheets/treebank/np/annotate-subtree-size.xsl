<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This stylesheet annotates the head of the NP for:
    - whether it has multiple modifiers;
    - the sequence of subtree sizes for preceding and following modifiers, 
    e.g.: @preceding-subtree-sizes="2 1", when the earliest preceding modifier subtree
    has two words and the next has one.
    
    NB! Emphasizers don't enlarge the tree size, e.g. καὶ ἄλλα θυμαλγέα ἔπεα has two
    subtrees of size 1, despite the καὶ being appended under the first modifier.
    This needs to be done in order to remove many cases that artificially "inflate" the 
    number of ascending/descending contours caused by emphasizers stuck to the first modifier.
    
    NB! Only np-heads with multiple modifiers get @preceding- and @following-subtree-sizes,
    but all np-heads will have @preceding- and @following-subtree-contour. This is because 
    we want to supply a value for the solr index for the facets.
    -->
    
    <xsl:include href="../utils.xsl"/>
    
    <xsl:template match="word[@np-head='true']">
        <xsl:copy>
            <xsl:variable name="substantive-id" select="@id"/>
            <!-- Modifiers: what does it all mean? 
                They are ATR or ATR_CO (minus articles), 
                APOS and APOS_CO; 
                they can be direct children of substantives, 
                but it may also be more complicated than that:
                - they may be coordinated by a COORD 
                (multiple coordination is also possible!);
                - they may be part of PPs, introduced by AuxP;
                - some weird abominable combination of the above.
                Therefore, we don't care about what connects them to 
                the substantive, as long as it's only
                an AuxP or a COORD in whatever combination. 
                Subtree counts are counted from the ATR, but, when there's an ancestor AuxP, 
                we add that to the overall count for that subtree. This means that an AuxP
                can be counted multiple times, but that's OK! Jamie has given his blessing,
                and I sort of agree with it, conceptually, too, or at least I don't vehemently object to it, for now.
                -->
            <xsl:variable name="modifiers" as="node()*">
                <xsl:apply-templates select="word" mode="find-modifier"/>
            </xsl:variable>
            <xsl:variable name="preceding-modifiers" select="$modifiers[xs:integer(@id) &lt; xs:integer($substantive-id)]"/>
            <xsl:variable name="following-modifiers" select="$modifiers[xs:integer(@id) &gt; xs:integer($substantive-id)]"/>
            <xsl:choose>
                <xsl:when test="count($modifiers) &gt; 1">
                    <xsl:attribute name="multiple-modifiers" select="true()"/>
                    <xsl:if test="$preceding-modifiers">
                        <xsl:attribute name="preceding-subtree-sizes">
                            <xsl:apply-templates select="$preceding-modifiers" mode="subtree-size">
                                <xsl:with-param name="substantive-id" select="$substantive-id"/>
                            </xsl:apply-templates>                            
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$following-modifiers">
                        <xsl:attribute name="following-subtree-sizes">
                            <xsl:apply-templates select="$following-modifiers" mode="subtree-size">
                                <xsl:with-param name="substantive-id" select="$substantive-id"/>
                            </xsl:apply-templates>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="multiple-modifiers" select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="word" mode="subtree-size">
        <xsl:param name="substantive-id"/>
        <xsl:value-of select="count(descendant-or-self::word[not(tb:is-punctuation(.) or tb:is-emphasizer(.))]) 
            + count(ancestor::word[ancestor::word/@id = $substantive-id][@relation='AuxP'])"/>
        <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
        </xsl:if>    
    </xsl:template>
    
    <xsl:template match="word" mode="find-modifier">
        <xsl:choose>
            <xsl:when test="@relation = ('ATR', 'ATR_CO', 'APOS', 'APOS_CO') and not(tb:is-article(.))">
                <xsl:sequence select="."/>                
            </xsl:when>
            <xsl:when test="@relation = ('COORD', 'AuxP')">
                <xsl:apply-templates select="word" mode="find-modifier"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>

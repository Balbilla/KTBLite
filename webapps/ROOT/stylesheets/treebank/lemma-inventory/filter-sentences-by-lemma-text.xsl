<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tb="https://papygreek.hum.helsinki.fi/py/"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <xsl:import href="cocoon://_internal/url/reverse.xsl"/>
    <xsl:include href="../utils.xsl"/>
    <xsl:include href="../noun-phrase-common-display.xsl"/>
    
    <xsl:template match="sentence">
        <xsl:variable name="real-text">
            <!-- I need this variable because I'm using this stylesheet for the display of both text and corpus. -->
            <xsl:choose>
                <xsl:when test="$text">
                    <xsl:value-of select="$text"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../../@text"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <xsl:if test="not($text)">
                <td>
                    <xsl:value-of select="$real-text"/>
                </td>
            </xsl:if>
            <td>
                <a href="{kiln:url-for-match('sentence', ($corpus, $real-text, @id), 0)}">
                    <xsl:value-of select="@id"/>
                </a>
            </td>
            <td>
                <xsl:apply-templates select=".//word[@lemma = $lemma][@relation = ('ATR', 'ATR_CO')]" mode="display-position"/><!-- parameter is in the template that's calling this stylesheet -->
            </td>
            <td>
                <xsl:apply-templates select=".//word" mode="display-word-pos-highlight">
                    <xsl:sort select="number(@id)" />
                </xsl:apply-templates>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="word" mode="display-np-word">    
        <span class="word-pos-{tb:get-pos(.)}">
            <xsl:value-of select="@form"/>
        </span>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="word" mode="display-position">
        <xsl:variable name="adjective-id" select="xs:integer(@id)"/>
        <xsl:variable name="substantive-id" select="xs:integer(ancestor::word[tb:is-substantive(.)][1]/@id)"/>
        <xsl:choose>
            <xsl:when test="$adjective-id &lt; $substantive-id">
                <xsl:text>before</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>after</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="display-sentences">
        <xsl:param name="sentences"/>
        <p>This is no longer a generic display for any lemma, but it has been configured to show adjectives. Needs refactoring 
        when the time allows it. When there is no value for 'position', this means that the lemma is used in the sentence in another
        function, i.e. not as an ATR or ATR_CO.</p>
        <table class="tablesorter">
            <thead>
                <tr>
                    <xsl:if test="not($text)">
                        <th>
                            <xsl:text>Text</xsl:text>
                        </th>
                    </xsl:if>
                    <th scope="col">
                        <xsl:text>№</xsl:text>
                    </th>
                    <th scope="col">
                        <xsl:text>Position</xsl:text>
                    </th>
                    <th scope="col">
                        <xsl:text>Sentence</xsl:text>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="$sentences"/>
            </tbody>
        </table>
    </xsl:template>
    
</xsl:stylesheet>

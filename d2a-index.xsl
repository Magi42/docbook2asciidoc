<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Index                                                                   -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- If keeping index, create index.asciidoc file, add include to book.asciidoc file -->
  <xsl:template match="index" mode="chunk">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:value-of select="util:carriage-returns(2)"/>
        <xsl:text>include::index.asciidoc[]</xsl:text>
        <xsl:result-document href="index.asciidoc">
          <xsl:apply-templates select="." mode="#default"/>
        </xsl:result-document>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- If keeping index, output heading markup in index file -->
  <xsl:template match="index">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <!-- Index should be at main level when book has parts. -->
      <xsl:when test="$strip-indexterms= 'false' and preceding::part">
        <xsl:text>= Index</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>== Index</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Handling for in-text index markup -->
  <!-- Specific handling for indexterms in emphasis elements, to override emphasis template that was ignoring indexterms -->
  <xsl:template match="indexterm | indexterm[parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise><xsl:text>(((</xsl:text><xsl:apply-templates/><xsl:text>)))</xsl:text></xsl:otherwise>
    </xsl:choose>

    <!-- Without the newline, there will be trouble -->
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="indexterm[@class='startofrange'][not(*/@sortas)] | indexterm[@class='startofrange'][parent::emphasis][not(*/@sortas)]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:text>(((</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>, id="</xsl:text>
        <xsl:value-of select="@id | @xml:id"/>
        <xsl:text>", range="startofrange")))</xsl:text>

        <!-- Without the newlines, there will be trouble -->
        <xsl:text>&#xa;&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="indexterm[*/@sortas][not(@class='startofrange')] | indexterm[*/@sortas][parent::emphasis][not(@class='startofrange')]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <!-- Output indexterms with @sortas and both primary and secondary indexterms as docbook passthroughs. Not supported in Asciidoc markup. -->
      <xsl:when test="$strip-indexterms = 'false' and secondary"><xsl:text>pass:[</xsl:text><xsl:copy-of select="."/><xsl:text>]</xsl:text></xsl:when>
      <!-- When only primary term exists, output as asciidoc -->
      <xsl:otherwise><xsl:text>(((</xsl:text><xsl:apply-templates/><xsl:text>, sortas="</xsl:text><xsl:value-of select="primary/@sortas"/><xsl:text>")))</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Output indexterms with both @sortas and @startofrange as docbook passthroughs. Not supported in Asciidoc markup. -->
  <xsl:template match="indexterm[@class='startofrange' and */@sortas]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise><xsl:text>pass:[</xsl:text><xsl:copy-of select="."/><xsl:text>]</xsl:text></xsl:otherwise>
    </xsl:choose>  
  </xsl:template>
  
  <xsl:template match="indexterm[@class='endofrange'] | indexterm[@class='endofrange'][parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise><xsl:text>(((range="endofrange", startref="</xsl:text><xsl:value-of select="@startref"/><xsl:text>")))</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="indexterm/primary | indexterm/primary[parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:text>"</xsl:text>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="indexterm/secondary | indexterm/secondary[parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:text>, "</xsl:text>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:text>"</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="indexterm/tertiary | indexterm/tertiary[parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:text>, "</xsl:text>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="indexterm/see | indexterm/see[parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:text>, see="</xsl:text>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="indexterm/seealso | indexterm/seealso[parent::emphasis]">
    <xsl:choose>
      <xsl:when test="$strip-indexterms = 'true'"/>
      <xsl:otherwise>
        <xsl:text>, seealso="</xsl:text>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:apply-templates/>
        <xsl:if test="contains(., '+') or contains(., '_') or contains(., '#')">$$</xsl:if>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Normalize space in indexterms -->
  <xsl:template match="indexterm/text() | indexterm/*/text()">
    <xsl:call-template name="normalize-text-whitespace"/>
  </xsl:template>

  <xsl:template match="@*|node()" mode="copy-and-drop-indexterms">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="copy-and-drop-indexterms"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="indexterm" mode="copy-and-drop-indexterms"/>
</xsl:stylesheet>

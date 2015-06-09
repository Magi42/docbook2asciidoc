<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Links                                                                   -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <xsl:template match="ulink">
    <xsl:text>link:$$</xsl:text>
    <xsl:value-of select="@url" />
    <xsl:text>$$[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="email">
    <xsl:text>pass:[</xsl:text>
    <xsl:element name="email">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:text>&#xE801;&#xE801;</xsl:text>
    <xsl:value-of select="@linkend" />
    <xsl:text>&#xE802;&#xE802;</xsl:text>
  </xsl:template>

  <xsl:template match="link" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:choose>
      <!-- Hyperlink -->
      <xsl:when test="@xlink:href">
        <xsl:if test="@xlink:href != text()">
          <xsl:text>link:</xsl:text>
        </xsl:if>
        <xsl:value-of select="@xlink:href"/>
        <xsl:if test="@xlink:href != text()">
          <xsl:text>[</xsl:text>
          <xsl:value-of select="normalize-space(text())"/>
          <xsl:text>]</xsl:text>
        </xsl:if>
      </xsl:when>

      <!-- AsciiDoc link -->
      <xsl:otherwise>
        <xsl:text>&#xE801;&#xE801;</xsl:text>
        <xsl:value-of select="@linkend" />
        <xsl:text>,</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#xE802;&#xE802;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ulink/text()">
    <xsl:value-of select="replace(., '\n\s+', ' ', 'm')"/>
  </xsl:template>
</xsl:stylesheet>

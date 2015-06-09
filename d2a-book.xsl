<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
 xpath-default-namespace="http://docbook.org/ns/docbook"
 exclude-result-prefixes="util">

  <!-- ======================================================================= -->
  <!-- Book                                                                    -->
  <!-- ======================================================================= -->
  <xsl:template match="/book">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title"/>
      </xsl:when>
      <xsl:when test="bookinfo/title">
        <xsl:apply-templates select="bookinfo/title"/>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$chunk-output != 'false'">
        <xsl:apply-templates select="*[not(self::title)]" mode="chunk"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="book/title|bookinfo/title">
    <xsl:text>= </xsl:text>
    <xsl:value-of select="."/>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Book info                                                               -->
  <!-- ======================================================================= -->
  
  <!-- Output bookinfo children into book-docinfo.xml -->
  <xsl:template match="bookinfo" mode="#all">
    <xsl:result-document href="{$bookinfo-doc-name}">
      <xsl:apply-templates mode="bookinfo-children"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="bookinfo/*" mode="bookinfo-children">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- ======================================================================= -->
  <!-- Dedications                                                             -->
  <!-- ======================================================================= -->
  
  <xsl:template match="dedication">
    <xsl:call-template name="process-id"/>
    <xsl:text>[dedication]</xsl:text>
    <xsl:value-of select="util:carriage-returns(1)"/>
    <xsl:text>== Dedication</xsl:text>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Colophon (at the back of the book)                                      -->
  <!-- ======================================================================= -->
  
  <xsl:template match="colophon">
    <xsl:call-template name="process-id"/>
    <xsl:choose>
      <xsl:when test="preceding::part">
        <xsl:text>= Colophon</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>== Colophon</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:choose>
      <xsl:when test="para/text()"><xsl:apply-templates select="*[not(self::title)]"/></xsl:when>
      <xsl:otherwise><xsl:text>(FILL IN)</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

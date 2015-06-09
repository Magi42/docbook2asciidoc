<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Side info                                                               -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <xsl:template match="table|informaltable">
    <xsl:call-template name="process-id"/>
    <xsl:apply-templates select="." mode="title"/>
    <xsl:if test="descendant::thead">
      <xsl:text>[options="header"]</xsl:text>
    </xsl:if>
    <xsl:text>&#xa;|===============&#xa;</xsl:text>
    <xsl:apply-templates select="descendant::row"/>
    <xsl:text>&#xa;|===============&#xa;&#xa;</xsl:text>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>

  <xsl:template match="row">
    <xsl:for-each select="entry">
      <xsl:text>|</xsl:text>
      <xsl:apply-templates/>
    </xsl:for-each>
    <xsl:if test="not (entry/para)">
      <xsl:value-of select="util:carriage-returns(1)"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="entry/para|entry/simpara">
    <xsl:call-template name="process-id"/>
    <xsl:apply-templates select="node()"/>
    <xsl:choose>
      <xsl:when test="following-sibling::para|following-sibling::simpara">
        <!-- Two carriage returns if para has following para siblings in the same entry -->
        <xsl:value-of select="util:carriage-returns(2)"/>
      </xsl:when>
      <xsl:when test="parent::entry[not(following-sibling::entry)]">
        <!-- One carriage return if last para in last entry in row -->
        <xsl:value-of select="util:carriage-returns(1)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

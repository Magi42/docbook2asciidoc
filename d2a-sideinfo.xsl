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

  <xsl:template match="remark">
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
    <xsl:copy-of select="."/>
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
  </xsl:template>
    
  <xsl:template match="footnote">
    <!-- When footnote has @id, output as footnoteref with @id value, 
         in case there are any corresponding footnoteref elements -->
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:text>footnoteref:[</xsl:text>
        <xsl:value-of select="@id"/><xsl:text>,</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>footnote:[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="footnoteref">
    <xsl:text>footnoteref:[</xsl:text><xsl:value-of select="@linkend"/><xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="footnote/para">
    <!--Special handling for footnote paras to contract whitespace-->
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="tip|warning|note|caution|important">
    <xsl:call-template name="conditional-block-element-start"/>
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;[</xsl:text>
    <xsl:value-of select="upper-case(name())"/>
    <xsl:text>]&#xa;</xsl:text>
    <xsl:apply-templates select="." mode="title"/>
    <xsl:text>====&#xa;</xsl:text>
    <xsl:apply-templates select="node()[not(self::title)]"/>
    <xsl:text>====&#xa;</xsl:text>
    <xsl:value-of select="util:carriage-returns(1)"/>
    <xsl:call-template name="conditional-block-element-end"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>

  <xsl:template match="sidebar">
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;.</xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:text>****&#xa;</xsl:text>
    <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:text>&#xa;****&#xa;</xsl:text>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>
</xsl:stylesheet>

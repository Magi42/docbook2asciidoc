<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Figures                                                                 -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

<!-- figure -->
<!-- Screenshots are treated as equal to normal figures -->
<xsl:template match="figure | informalfigure | screenshot">
  <xsl:call-template name="conditional-block-element-start"/>

  <!-- In lists -->
  <xsl:if test="ancestor::listitem and preceding-sibling::element()">
    <xsl:text>+</xsl:text><xsl:value-of select="util:carriage-returns(1)"/>
  </xsl:if>

  <xsl:call-template name="process-id"/>

  <!-- Only (normal formal) figures have a title -->
  <xsl:if test="self::figure">
    <xsl:text>.</xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:if>

  <xsl:text>image::</xsl:text>

  <!-- Refer the image node.
       Here we need to select only one of the imageobjects;
       prefer ones with fo (PDF) role, as they are presumably bigger -->
  <xsl:variable name="imagenode">
    <xsl:choose>
      <xsl:when test="mediaobject/imageobject[@role='fo']">
        <xsl:copy-of select="mediaobject/imageobject[@role='fo']/*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="mediaobject/imageobject[1]/*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="process-imagedata-fileref">
    <xsl:with-param name="fileref" select="$imagenode/imagedata[1]/@fileref"/>
  </xsl:call-template>

  <xsl:variable name="scale">
    <xsl:call-template name="process-image-scale">
      <xsl:with-param name="imagenode" select="$imagenode"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Image options: scale -->
  <!-- Alt text or link are not supported -->
  <xsl:text>[</xsl:text>
  <xsl:if test="exists($scale) and $scale!=''">
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$scale"/>
    <xsl:text>%, </xsl:text>
    <xsl:value-of select="$scale"/>
    <xsl:text>%</xsl:text>
  </xsl:if>
  <xsl:text>]&#xa;</xsl:text>
  <xsl:call-template name="conditional-block-element-end"/>

  <!-- Always have an empty line after image. -->
  <!-- In lists, this is especially needed, because otherwise, a following "+" line is ineffective -->
  <xsl:value-of select="util:carriage-returns(1)"/>
</xsl:template>

<!-- Returns image scaling parameter -->
<xsl:template name="process-image-scale">
  <xsl:param name="imagenode"/>
  <xsl:value-of select="substring-before($imagenode/imagedata/@scale, '%')"/>
</xsl:template>

<!-- Returns the path to the image file.
     You can override this to alter the filename or path. -->
<xsl:template name="process-imagedata-fileref">
  <xsl:param name="fileref"/>
  <xsl:value-of select="$fileref"/>
</xsl:template>

<xsl:template match="inlinemediaobject">image:<xsl:value-of select="imageobject[@role='web']/imagedata/@fileref"/>[]</xsl:template>
  
<xsl:template match="literallayout">
....
<xsl:apply-templates/>
....
</xsl:template>

</xsl:stylesheet>

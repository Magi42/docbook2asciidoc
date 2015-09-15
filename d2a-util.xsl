<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Utility functions/templates                                             -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- Print a given number of newlines -->
  <xsl:function name="util:carriage-returns">
    <xsl:param name="n"/>
    <xsl:value-of select="string-join(for $i in (1 to $n) return '&#10;', '')"/>
  </xsl:function>

  <!-- Strip white-space from a string in a controlled manner -->
  <xsl:template name="strip-whitespace">
    <!-- Assumption is that $text-to-strip will be a text() node --> 
    <xsl:param name="text-to-strip" select="."/>

    <!-- By default, don't strip any whitespace -->
    <xsl:param name="leading-whitespace"/>

    <xsl:param name="trailing-whitespace"/>

    <xsl:choose>
      <xsl:when test="($leading-whitespace = 'strip') and ($trailing-whitespace = 'strip')">
        <xsl:value-of select="replace(replace(., '^\s+', '', 'm'), '\s+$', '', 'm')"/>
      </xsl:when>
      <xsl:when test="$leading-whitespace = 'strip'">
        <xsl:value-of select="replace(., '^\s+', '', 'm')"/>
      </xsl:when>
      <xsl:when test="$trailing-whitespace = 'strip'">
        <xsl:value-of select="replace(., '\s+$', '', 'm')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Process an id or xml:id attribute -->
  <xsl:template name="process-id">
    <xsl:if test="@xml:id or @id">
      <xsl:text xml:space="preserve">[[</xsl:text>

      <!-- Assume only either to exist -->
      <xsl:value-of select="@xml:id"/>
      <xsl:value-of select="id"/>

      <xsl:text xml:space="preserve">]]&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Start conditional block element -->
  <xsl:template name="conditional-block-element-start">
    <xsl:if test="exists(@condition)">
      <xsl:text>ifdef::</xsl:text>
      <xsl:value-of select="@condition"/>
      <xsl:text>[]&#xa;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- End conditional block element -->
  <xsl:template name="conditional-block-element-end">
    <xsl:if test="exists(@condition)">
      <xsl:text>endif::</xsl:text>
      <xsl:value-of select="@condition"/>
      <xsl:text>[]&#xa;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Extracts filename from path after last slash -->
  <xsl:function name="util:getFilename">
    <xsl:param name="uri"/>

    <!-- Resolve the filename recursively -->
    <xsl:choose>
      <xsl:when test="contains($uri,'/')">
        <xsl:value-of select="util:getFilename(substring-after($uri,'/'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$uri" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
</xsl:stylesheet>

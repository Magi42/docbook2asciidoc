<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Meta                                                                    -->
<!--                                                                         -->
<!-- This file contains various elements that will not be included in the    -->
<!-- output.                                                                 -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- XML comments -->
  <xsl:template match="//comment()">
    <xsl:choose>
      <xsl:when test="contains(., '&#xa;')">
        <xsl:text>&#xa;////&#xa;</xsl:text>
        <xsl:copy/>
        <xsl:text>&#xa;////&#xa;</xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>&#xa;// </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Processing instructions like ?dbfo, etc. -->
  <xsl:template match="processing-instruction()">
    <xsl:text>+++</xsl:text>
    <xsl:copy-of select="."/>
    <xsl:text>+++</xsl:text>
  </xsl:template>
</xsl:stylesheet>

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
    <!-- If a comment is inside a list, it needs continuation or otherwise it will break the list -->
    <xsl:if test="ancestor::listitem and preceding-sibling::element()">
      <xsl:text>+&#xa;</xsl:text>
    </xsl:if>

    <xsl:choose>
      <!-- If there is a newline, use block comment -->
      <xsl:when test="contains(., '&#xa;')">
        <!-- TODO This should be somehow conditional -->
        <xsl:text>&#xa;</xsl:text>

        <xsl:text>////&#xa;</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&#xa;////&#xa;</xsl:text>
      </xsl:when>

      <!-- Strip out a DocBook workaround to terminate comments that start in listings to fix syntax highlighting in XEmacs -->
      <xsl:when test="normalize-space(.) = '*/'">
        <!-- Just remove such comments which have no meaning in AsciiDoc -->
      </xsl:when>

      <!-- If no newline, can use single-line comment -->
      <xsl:otherwise>
        <!-- TODO May not have space after the //, because it causes crazy newline behaviour in rewrapping -->
        <xsl:text>//</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Processing instructions like ?dbfo, etc. -->
  <xsl:template match="processing-instruction()">
    <xsl:text>+++</xsl:text>
    <xsl:copy-of select="."/>
    <xsl:text>+++&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>

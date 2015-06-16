<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Body elements                                                           -->
<!--                                                                         -->
<!--  - Paragraphs                                                           -->
<!--  - Quotations                                                           -->
<!--  - Phrases, etc.                                                        -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
 xpath-default-namespace="http://docbook.org/ns/docbook"
 exclude-result-prefixes="util">

  <xsl:template match="para|simpara">
    <xsl:choose>
      <xsl:when test="ancestor::callout"/>
      <xsl:otherwise>
        <xsl:call-template name="process-id"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- If it's the 2nd+ para inside a listitem, glossdef, or callout (but not a nested admonition or sidebar), precede it with a plus symbol -->
    <xsl:if test="ancestor::listitem and preceding-sibling::element()">
      <xsl:choose>
        <xsl:when test="not(ancestor::warning|ancestor::note|ancestor::caution|ancestor::tip|ancestor::important) and not(ancestor::sidebar)">
          <xsl:text>+</xsl:text><xsl:value-of select="util:carriage-returns(1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="util:carriage-returns(1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="ancestor::glossdef and preceding-sibling::element()">
      <xsl:text>+</xsl:text><xsl:value-of select="util:carriage-returns(1)"/>
    </xsl:if>
    <xsl:if test="ancestor::callout and preceding-sibling::element()">
      <xsl:text>+</xsl:text><xsl:value-of select="util:carriage-returns(1)"/>
    </xsl:if>

    <!-- Include cleaned paragraph text: unindent, etc. -->
    <xsl:call-template name="rewrap-para"/>
    <xsl:text>&#xa;</xsl:text>

    <!-- Control number of blank lines following para, if it's inside a listitem or glossary -->
    <xsl:choose>
      <xsl:when test="following-sibling::glossseealso">
        <xsl:value-of select="util:carriage-returns(1)"/>
      </xsl:when>
      <xsl:when test="ancestor::listitem and following-sibling::element()">
        <xsl:value-of select="util:carriage-returns(1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="util:carriage-returns(1)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Rewrap paragraph body text -->
  <xsl:template name="rewrap-para">
    <xsl:variable name="content">
      <xsl:apply-templates/>
    </xsl:variable>

    <xsl:variable name="wrapped">
      <xsl:value-of select="replace(concat($content,' '), '(.{0,80}) ', '$1&#xa;')"/>
    </xsl:variable>

    <!-- Remove trailing newline -->
    <xsl:choose>
      <xsl:when test="ends-with($wrapped, '&#xa;')">
        <xsl:value-of select="substring($wrapped, 1, string-length($wrapped) - 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$wrapped"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Text inside paras and many other elements must control its leading and trailing whitespace -->
  <xsl:template match="para/text() | listitem/text()">
    <xsl:call-template name="normalize-text-whitespace"/>
  </xsl:template>

  <xsl:template name="normalize-text-whitespace">
    <xsl:variable name="starts-with-whitespace">
      <xsl:value-of select="starts-with(., ' ') or starts-with(., '&#xa;') or starts-with(., '&#x9;')"/>
    </xsl:variable>

    <!-- Add a space if
         1) there was one originally
         2) there's a newline after a sibling; a newline after an inline element;
            but not if the element was an indexterm, which will have newline -->
    <xsl:if test="$starts-with-whitespace='true' and exists(preceding-sibling::*[1]/self::element()) and empty(preceding-sibling::*[1]/self::indexterm)">
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:value-of select="normalize-space(.)"/>

    <!--
    <xsl:variable name="ends-with-whitespace">
      <xsl:value-of select="ends-with(., ' ') or ends-with(., '&#xa;') or ends-with(., '&#x9;')"/>
    </xsl:variable> -->

    <!-- Must add a space if there's an inline element following,
         but not if this text is just whitespace -->
    <xsl:if test="exists(following-sibling::*[1]/self::element()) and normalize-space(.) != ''">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="formalpara">
    <xsl:call-template name="process-id"/>
    <!-- Put formalpara <title> in bold (drop any inline formatting) -->
    <xsl:text>*</xsl:text>
    <xsl:value-of select="title"/>
    <xsl:text>* </xsl:text>
    <xsl:apply-templates select="node()[not(self::title)]"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>

  <!-- Same handling for blockquote and epigraph; convert to AsciiDoc quote block -->
  <xsl:template match="blockquote|epigraph">
    <xsl:call-template name="process-id"/>
    <xsl:apply-templates select="." mode="title"/>

    <xsl:text>[quote</xsl:text>

    <xsl:if test="attribution">
      <xsl:text>, </xsl:text>
      <!-- Simple processing of attribution elements, placing a space between each
           and skipping <citetitle>, which is handled separately below -->
      <xsl:for-each select="attribution/text()|attribution//*[not(*)][not(self::citetitle)]">
        <!--Output text as is, except escape commas as &#44; entities for 
             proper AsciiDoc attribute processing -->
        <xsl:value-of select="normalize-space(replace(., ',', '&#xE803;#44;'))"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="attribution/citetitle">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="attribution/citetitle"/>
    </xsl:if>

    <xsl:text>]&#xa;____&#xa;</xsl:text>
    <xsl:apply-templates select="node()[not(self::title or self::attribution)]"/>
    <xsl:text>&#xa;____&#xa;</xsl:text>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>

  <!-- Handling for inline quote elements -->
  <xsl:template match="quote">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="phrase/text()">
    <xsl:text/>
    <xsl:value-of select="replace(., '\n\s+', ' ', 'm')"/>
    <xsl:text/>
  </xsl:template>

  <!-- Other text: just normalize -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
</xsl:stylesheet>

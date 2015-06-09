<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Lists                                                                   -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- ======================================================================= -->
  <!-- variablelist                                                            -->
  <!-- ======================================================================= -->

  <xsl:template match="variablelist">
    <xsl:choose>
      <!-- When variablelist has a varlistentry with more than one term, or a nested variablelist, output as passthrough -->
      <xsl:when test="./varlistentry/term[2] | .//variablelist">
        <xsl:text>&#xa;++++&#xa;</xsl:text>
        <xsl:choose>
          <xsl:when test="$strip-indexterms='false'">
            <xsl:copy-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates mode="copy-and-drop-indexterms"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#xa;++++</xsl:text>
        <xsl:value-of select="util:carriage-returns(2)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="process-id"/>
        <xsl:for-each select="varlistentry">
          <xsl:apply-templates select="term,listitem"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="term">
    <xsl:apply-templates select="node()"/>
    <xsl:text>:: </xsl:text>
  </xsl:template>

  <!-- Strip leading whitespace from first text node in <term>, if it does not have preceding element siblings --> 
  <xsl:template match="term[count(element()) != 0]/text()[1][not(preceding-sibling::element())]">
    <xsl:call-template name="strip-whitespace">
      <xsl:with-param name="text-to-strip" select="."/>
      <xsl:with-param name="leading-whitespace" select="'strip'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Strip trailing whitespace from last text node in <term>, if it does not have following element siblings --> 
  <xsl:template match="term[count(element()) != 0]/text()[not(position() = 1)][last()][not(following-sibling::element())]">
    <xsl:call-template name="strip-whitespace">
      <xsl:with-param name="text-to-strip" select="."/>
      <xsl:with-param name="trailing-whitespace" select="'strip'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- If term has just one text node (no element children), just normalize space in it -->
  <xsl:template match="term[count(element()) = 0]/text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- Text nodes in <term> that are between elements that contain only whitespace should be normalized to one space -->
  <xsl:template match="term/text()[not(position() = 1)][not(position() = last())][matches(., '^[\s\n]+$', 'm')]">
    <xsl:value-of select="replace(., '^[\s\n]+$', ' ', 'm')"/>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Other lists                                                             -->
  <!-- ======================================================================= -->

  <xsl:template match="itemizedlist | orderedlist">
    <xsl:call-template name="process-id"/>

    <!-- Optional list style options -->
    <xsl:if test="@spacing">
      <xsl:text>[options="</xsl:text>
      <xsl:value-of select="@spacing"/>
      <xsl:text>"]&#xa;</xsl:text>
    </xsl:if>

    <xsl:for-each select="listitem">
      <xsl:choose>
        <xsl:when test="parent::itemizedlist">
          <xsl:text>* </xsl:text>
        </xsl:when>
        <xsl:when test="parent::orderedlist">
          <xsl:text>. </xsl:text>
        </xsl:when>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="para">
          <xsl:apply-templates/>
        </xsl:when>

        <xsl:otherwise>
          <!-- If there's no para inside, text has to be wrapped and newline
               added as they were inside a para.
               This is copied from para template. -->
          <xsl:call-template name="rewrap-para"/>
          <xsl:text>&#xa;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="listitem">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="simplelist">
    <xsl:value-of select="util:carriage-returns(1)"/>
    <xsl:call-template name="process-id"/>
    <xsl:for-each select="member">
      <xsl:apply-templates/>
      <xsl:if test="position() &lt; last()">
        <xsl:text> + &#xa;</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="util:carriage-returns(2)"/>
  </xsl:template>

  <xsl:template match="member/text()">
    <xsl:value-of select="replace(., '^\s+', '', 'm')"/>
  </xsl:template>
</xsl:stylesheet>

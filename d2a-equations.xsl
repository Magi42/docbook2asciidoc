<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Equations                                                               -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

<xsl:template match="equation">
<xsl:call-template name="process-id"/>
<xsl:choose>
  <!-- If nested latex, use the macro -->
  <xsl:when test="mathphrase[@role='tex']">
<xsl:text xml:space="preserve">[latexmath]</xsl:text>
<xsl:choose>
<!-- Set the below parameter to "true" only for DocBook books that have numbered equations but no titles -->
<!-- This will pass through a placeholder title -->
<xsl:when test="$add-equation-titles = 'true'">
<xsl:value-of select="util:carriage-returns(1)"/>
<xsl:text xml:space="preserve">.FILL IN TITLE</xsl:text>
</xsl:when>
<xsl:otherwise>
.<xsl:apply-templates mode="title"/>
</xsl:otherwise>
</xsl:choose>
++++++++++++++++++++++++++++++++++++++
<xsl:apply-templates/>
++++++++++++++++++++++++++++++++++++++
  </xsl:when>
  <!-- If nested docbook or mediaobject, just pass through-->  
  <xsl:otherwise>
<xsl:choose>
<xsl:when test="$add-equation-titles = 'true'">
<xsl:text xml:space="preserve">.FILL IN TITLE</xsl:text>
</xsl:when>
<xsl:otherwise>
.<xsl:apply-templates mode="title"/>
</xsl:otherwise>
</xsl:choose>
++++++++++++++++++++++++++++++++++++++
<xsl:copy-of select="."/>
++++++++++++++++++++++++++++++++++++++
  </xsl:otherwise>
</xsl:choose>
<xsl:value-of select="util:carriage-returns(1)"/>
</xsl:template>

<xsl:template match="informalequation">
<xsl:choose>
  <!-- If nested latex, use the macro -->
  <xsl:when test="mathphrase[@role='tex']">
<xsl:text xml:space="preserve">[latexmath]</xsl:text>
++++++++++++++++++++++++++++++++++++++
<xsl:apply-templates/>
++++++++++++++++++++++++++++++++++++++
  </xsl:when>
  <!-- If nested docbook or mediaobject, just pass through-->  
  <xsl:otherwise>
++++++++++++++++++++++++++++++++++++++
<xsl:copy-of select="."/>
++++++++++++++++++++++++++++++++++++++
  </xsl:otherwise>
</xsl:choose>
<xsl:value-of select="util:carriage-returns(1)"/>
</xsl:template>

<xsl:template match="inlineequation">
  <xsl:choose>
  <xsl:when test="mathphrase[@role='tex']">
latexmath:[<xsl:copy-of select="."/>]
  </xsl:when>
  <xsl:otherwise>
pass:[<xsl:copy-of select="."/>]    
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

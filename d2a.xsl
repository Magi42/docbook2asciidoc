<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
 xpath-default-namespace="http://docbook.org/ns/docbook"
 exclude-result-prefixes="util">
  
  <xsl:import href="d2a-book.xsl"/>
  <xsl:import href="d2a-body.xsl"/>
  <xsl:import href="d2a-codeblock.xsl"/>
  <xsl:import href="d2a-divisions.xsl"/>
  <xsl:import href="d2a-equations.xsl"/>
  <xsl:import href="d2a-figures.xsl"/>
  <xsl:import href="d2a-glossary.xsl"/>
  <xsl:import href="d2a-index.xsl"/>
  <xsl:import href="d2a-inline.xsl"/>
  <xsl:import href="d2a-links.xsl"/>
  <xsl:import href="d2a-lists.xsl"/>
  <xsl:import href="d2a-sideinfo.xsl"/>
  <xsl:import href="d2a-table.xsl"/>
  <xsl:import href="d2a-util.xsl"/>
  <xsl:import href="d2a-meta.xsl"/>

  <!-- Mapping to allow use of XML reserved chars in AsciiDoc markup elements, e.g., angle brackets for cross-references --> 
  <xsl:character-map name="xml-reserved-chars">
    <xsl:output-character character="&#xE801;" string="&lt;"/>
    <xsl:output-character character="&#xE802;" string="&gt;"/>
    <xsl:output-character character="&#xE803;" string="&amp;"/>
    <xsl:output-character character='“' string="&amp;ldquo;"/>
    <xsl:output-character character='”' string="&amp;rdquo;"/>
    <xsl:output-character character="’" string="&amp;rsquo;"/>
  </xsl:character-map>

  <xsl:output method="xml" omit-xml-declaration="yes" use-character-maps="xml-reserved-chars"/>
  <xsl:param name="chunk-output">false</xsl:param>
  <xsl:param name="chunk-sections">false</xsl:param>
  <xsl:param name="bookinfo-doc-name">book-docinfo.xml</xsl:param>
  <xsl:param name="strip-indexterms">false</xsl:param>
  <xsl:param name="glossary-passthrough">false</xsl:param>
  <xsl:param name="add-equation-titles">false</xsl:param>

  <!-- Do not preserve whitespace anywhere -->
  <xsl:preserve-space elements=""/>
  <xsl:strip-space elements="table row entry tgroup thead"/>
</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Glossary                                                                -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

<xsl:template match="glossary">
  <xsl:choose>
    <xsl:when test="$glossary-passthrough != 'false'">
<xsl:call-template name="process-id"/>
<xsl:text>[glossary]
== Glossary

</xsl:text>
++++++++++++++++++++++++++++++++++++++
<xsl:choose>
  <xsl:when test="$strip-indexterms='false'">
    <xsl:copy-of select="*[not(local-name() = 'title')]"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="*[not(self::title)]" mode="copy-and-drop-indexterms"/>
  </xsl:otherwise>
</xsl:choose>
++++++++++++++++++++++++++++++++++++++
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-id"/>== <xsl:value-of select="title"/><xsl:value-of select="util:carriage-returns(2)"/>[glossary]<xsl:value-of select="util:carriage-returns(1)"/><xsl:apply-templates select="*[not(self::title)]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<xsl:template match="glossentry">
  <xsl:call-template name="process-id"/>
  <xsl:apply-templates select="glossterm"/><xsl:text>::&#10;</xsl:text><xsl:text>   </xsl:text><xsl:apply-templates select="glossdef"/>
</xsl:template>

<!-- Output glossary "See Also"s as hardcoded text. Asc to DB toolchain does not 
    currently retain any @id attrbutes for glossentry elements. -->
<xsl:template match="glossseealso">
  <xsl:choose>
    <xsl:when test="preceding-sibling::para">
      <xsl:text>+&#10;See Also </xsl:text><xsl:value-of select="id(@otherterm)/glossterm" /><xsl:choose>
        <xsl:when test="following-sibling::glossseealso"><xsl:value-of select="util:carriage-returns(1)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="util:carriage-returns(2)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>See Also </xsl:text><xsl:value-of select="id(@otherterm)/glossterm" /><xsl:value-of select="util:carriage-returns(2)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
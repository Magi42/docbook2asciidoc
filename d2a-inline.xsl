<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Inline elements                                                         -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <xsl:template match="phrase">
    <xsl:apply-templates />
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Emphasis                                                              -->
  <!-- ===================================================================== -->

  <!-- Bold emphasis -->
  <xsl:template match="emphasis[@role='bold'] | emphasis[@role='strong'] | guibutton | guilabel | parameter">
    <xsl:if test="guibutton | guilabel">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>**</xsl:text>
    <xsl:apply-templates />
    <xsl:text>**</xsl:text>
  </xsl:template>

  <!-- Italic emphasis and firstterm-->
  <xsl:template match="emphasis | firstterm">
    <xsl:text>__</xsl:text>
    <xsl:if test="contains(., '~') or contains(., '_')">
      <xsl:text>$$</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="contains(., '~') or contains(., '_')">
      <xsl:text>$$</xsl:text>
    </xsl:if>
    <xsl:text>__</xsl:text>
  </xsl:template>

  <xsl:template match="filename">__<xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if><xsl:apply-templates/><xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if>__</xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       filename, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="filename/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(replace(., '([\+])', '\\$1', 'm'))"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       emphasis, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="emphasis/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="command">__<xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if><xsl:apply-templates/><xsl:if test="contains(., '~') or contains(., '_')">$$</xsl:if>__</xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       command, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="command/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(replace(., '([\+])', '\\$1', 'm'))"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Literals                                                                -->
  <!-- ======================================================================= -->

  <xsl:template match="literal | code">
    <xsl:text>++</xsl:text>
    <xsl:if test='contains(., "+") or contains(., "&apos;") or contains(., "_")'>
      <xsl:text>$$</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test='contains(., "+") or contains(., "&apos;") or contains(., "_")'>
      <xsl:text>$$</xsl:text>
    </xsl:if>
    <xsl:text>++ </xsl:text>
  </xsl:template>

  <!-- Quote the text inside literals -->
  <xsl:template match="literal/text()">
    <xsl:value-of select="replace(replace(replace(., '\n\s+', ' ', 'm'), 'C\+\+', '\$\$C++\$\$', 'm'), '([\[\]\*\^~])', '\\$1', 'm')"/>
  </xsl:template>
  
  <xsl:template match="userinput">**`<xsl:apply-templates />`**</xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       userinput, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="userinput/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="replaceable">
    <xsl:choose>
      <xsl:when test="parent::literal">__<xsl:apply-templates />__</xsl:when>
      <xsl:otherwise>__++<xsl:apply-templates />++__</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       replaceable, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="replaceable/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="superscript">
    <xsl:text>^</xsl:text>
    <xsl:apply-templates />
    <xsl:text>^</xsl:text>
  </xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       superscript, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="superscript/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="subscript">
    <xsl:text>~</xsl:text>
    <xsl:apply-templates />
    <xsl:text>~</xsl:text>
  </xsl:template>

  <!-- Normalize-space() on text node below includes extra handling for child elements of
       subscript, to add needed spaces back in. (They're removed by normalize-space(), which
       normalizes the two text nodes separately.) -->
  <xsl:template match="subscript/text()">
    <xsl:if test="preceding-sibling::* and (starts-with(.,' ') or starts-with(.,'&#10;'))">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="following-sibling::* and (substring(.,string-length(.))=' ' or substring(.,string-length(.))='&#10;')">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Menu choices                                                          -->
  <!-- ===================================================================== -->
  <xsl:template match="menuchoice">
    <xsl:text>menu:</xsl:text>
    <xsl:for-each select="guimenu | guisubmenu | guimenuitem">
      <xsl:if test="position()=2">
        <xsl:text>[</xsl:text>
      </xsl:if>

      <xsl:if test="position()>2">
        <xsl:text> &gt; </xsl:text>
      </xsl:if>

      <xsl:value-of select="normalize-space(.)"/>
    </xsl:for-each>

    <xsl:if test="count(guimenu | guisubmenu | guimenuitem) > 1">
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

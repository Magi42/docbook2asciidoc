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
    <xsl:choose>
      <!-- Markup inside a conditional phrase -->
      <xsl:when test="exists(@condition) and exists(element())">
        <!-- Use the rough way, which may cause some additional whitespace in the text -->
        <!-- For some reason, there is an extra newline in lists, so we have to continue list text. -->
        <xsl:if test="not(ancestor::variablelist)">
          <xsl:text>&#xa;</xsl:text>
        </xsl:if>
        <xsl:call-template name="conditional-block-element-start"/>

        <xsl:apply-templates />
        <xsl:text>&#xa;</xsl:text>
        <xsl:call-template name="conditional-block-element-end"/>
      </xsl:when>

      <!-- No markup inside a conditional phrase -->
      <xsl:when test="exists(@condition)">
        <!-- This way is a bit more gentle with regards to whitespace, but may not contain inner markup -->
        <xsl:text>&#xa;ifdef::</xsl:text>
        <xsl:value-of select="@condition"/>
        <xsl:text>[</xsl:text>
        <xsl:apply-templates />
        <xsl:text>]</xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Emphasis                                                              -->
  <!-- ===================================================================== -->

  <!-- Bold emphasis -->
  <!-- We also convert replaceable as bold; converting it to custom class does
       not work in pass:quote macros, where it is often used. -->
  <xsl:template match="emphasis[@role='bold'] | emphasis[@role='strong'] | replaceable">
    <xsl:text>**</xsl:text>
    
    <xsl:variable name="content">
      <xsl:apply-templates />
    </xsl:variable>

    <!-- Often the emphasized text contains '*', which needs to be quoted -->
    <xsl:value-of select="replace($content, '\*', '++*++')"/>

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

  <!-- ===================================================================== -->
  <!-- Filenames                                                             -->
  <!-- ===================================================================== -->

  <xsl:template match="filename">
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

  <!-- ===================================================================== -->
  <!-- Commands                                                              -->
  <!-- ===================================================================== -->

  <xsl:template match="command">
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

  <!-- ===================================================================== -->
  <!-- Language Emphasis                                                     -->
  <!-- ===================================================================== -->

  <xsl:template match="classname | methodname | interfacename | package | guibutton | guilabel | parameter">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>]</xsl:text>
    <xsl:text>#</xsl:text>
    <xsl:apply-templates />
    <xsl:text>#</xsl:text>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Literals                                                                -->
  <!-- ======================================================================= -->

  <xsl:template match="literal | code">
    <xsl:text>++</xsl:text>
    <!-- TODO Why is this done? Doesn't seem to work in AsciiDoctor -->
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
    <!-- Literal text often contains quoted elements -->
    <xsl:variable name="unquoted">
      <xsl:value-of select="replace(replace(replace(., '&lt;', '&#xE801;', 'm'), '&gt;', '&#xE802;', 'm'), '&amp;', '&#xE803;', 'm')"/>
    </xsl:variable>
    <xsl:value-of select="replace($unquoted, '\n\s+', ' ', 'm')"/>
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

  <!-- ======================================================================= -->
  <!-- Superscripts and subscripts                                             -->
  <!-- ======================================================================= -->

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
    <!-- The freeform format does not work for single-level menu choices. -->
    <!-- The menu: macro would work with those, but it doesn't support whitespace
         or special characters in the first choice. -->
    <xsl:choose>
      <!-- Single-choice menu choices: just apply a style -->
      <xsl:when test="count(guimenu | guisubmenu | guimenuitem) = 1">
        <xsl:text>[menuchoice]#</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>#</xsl:text>
      </xsl:when>

      <!-- Multi-choice menu choices -->
      <xsl:otherwise>
        <xsl:text>"</xsl:text>
        <xsl:for-each select="guimenu | guisubmenu | guimenuitem">
          <xsl:if test="position() > 1">
            <xsl:text> &#xE802; </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:for-each>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

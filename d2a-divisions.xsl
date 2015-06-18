<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Document division elements                                              -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- ===================================================================== -->
  <!-- Part                                                                  -->
  <!-- ===================================================================== -->
  <xsl:template match="part" mode="chunk">
    <!-- Only bother chunking parts into a separate file if there's actually partintro content -->
    <xsl:variable name="part_content">
      <!-- Title and partintro (if present) -->
      <xsl:call-template name="process-id"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text xml:space="preserve">= </xsl:text>
      <xsl:apply-templates select="title"/>
      <xsl:value-of select="util:carriage-returns(2)"/>
      <xsl:apply-templates select="partintro" mode="#default"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="partintro">
        <xsl:variable name="doc-name">
          <xsl:text>part</xsl:text>
          <xsl:number count="part" level="any" format="i"/>
          <xsl:text>.asciidoc</xsl:text>
        </xsl:variable>
        <xsl:value-of select="util:carriage-returns(2)"/>
        <xsl:text>include::</xsl:text>
        <xsl:value-of select="$doc-name"/>
        <xsl:text>[]</xsl:text>
        <xsl:result-document href="{$doc-name}">
          <xsl:value-of select="$part_content"/>
        </xsl:result-document>
        <xsl:apply-templates select="*[not(self::title)][not(self::partintro)]" mode="chunk"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="util:carriage-returns(2)"/>
        <xsl:value-of select="$part_content"/>
        <xsl:apply-templates select="*[not(self::title)][not(self::partintro)]" mode="chunk"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="part">
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;= </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <xsl:template match="partintro">
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;[partintro]&#xa;</xsl:text>
    <xsl:apply-templates select="." mode="title"/>
    <xsl:text>&#xa;--&#xa;</xsl:text>
    <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:text>&#xa;--&#xa;</xsl:text>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Chapter chunking                                                      -->
  <!-- ===================================================================== -->
  
  <!-- Chunk output by any chapter-level division element -->
  <xsl:template match="chapter|appendix|preface|colophon|dedication|glossary|bibliography" mode="chunk">
    <xsl:variable name="chapter-doc-name">
      <xsl:call-template name="chapter-doc-name"/>
    </xsl:variable>

    <!-- Include the chapter-doc in the book-doc -->
    <xsl:value-of select="util:carriage-returns(1)"/>
    <xsl:text>include::</xsl:text>
    <xsl:value-of select="$chapter-doc-name"/>
    <xsl:text>[]&#xa;</xsl:text>

    <!-- Create the chapter-doc -->
    <xsl:result-document href="{$chapter-doc-name}">
      <xsl:apply-templates select="." mode="#default"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="chapter-doc-name">
    <!-- Determine source file name without extension -->
    <xsl:variable name="basefilename">
      <xsl:value-of select="substring-before(util:getFilename(base-uri()), '.')"/>
    </xsl:variable>

    <!-- Output to sub-directory if section-level chunking is enabled -->
    <xsl:if test="self::chapter and $chunk-sections != 'false'">
      <xsl:value-of select="concat($basefilename, '/')"/>
    </xsl:if>

    <xsl:choose>
      <!-- If possible, use the input file name for the output file -->
      <xsl:when test="$basefilename != ''">
        <xsl:value-of select="$basefilename"/>
      </xsl:when>

      <!-- Use automatic file names -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="self::chapter">
            <xsl:text>ch</xsl:text>
            <xsl:number count="chapter" level="any" format="01"/>
          </xsl:when>
          <xsl:when test="self::appendix">
            <xsl:text>app</xsl:text>
            <xsl:number count="appendix" level="any" format="a"/>
          </xsl:when>
          <xsl:when test="self::preface">
            <xsl:text>pr</xsl:text>
            <xsl:number count="preface" level="any" format="01"/>
          </xsl:when>
          <xsl:when test="self::colophon">
            <xsl:text>colo</xsl:text>
            <xsl:if test="count(//colophon) &gt; 1">
              <xsl:number count="colo" level="any" format="01"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="self::dedication">
            <xsl:text>dedication</xsl:text>
            <xsl:if test="count(//dedication) &gt; 1">
              <xsl:number count="dedication" level="any" format="01"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="self::glossary">
            <xsl:text>glossary</xsl:text>
            <xsl:if test="count(//glossary) &gt; 1">
              <xsl:number count="glossary" level="any" format="01"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="self::bibliography">
            <xsl:text>bibliography</xsl:text>
            <xsl:if test="count(//bibliography) &gt; 1">
              <xsl:number count="bibliography" level="any" format="01"/>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.asciidoc</xsl:text>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Chapter-level                                                         -->
  <!-- ===================================================================== -->

  <xsl:template match="chapter">
    <xsl:call-template name="process-id"/>
    <xsl:text>== </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template> 

  <xsl:template match="appendix">
    <xsl:call-template name="process-id"/>
    <xsl:text>[appendix]&#xa;== </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <xsl:template match="prefaceinfo"/>

  <xsl:template match="preface">
    <xsl:call-template name="process-id"/>
    <xsl:text>[preface]&#xa;</xsl:text>

    <!--Gather Author name(s): -->
    <xsl:text>[</xsl:text>
    <!-- For each author: -->
    <xsl:for-each select="prefaceinfo/author">
      <!--Dynamic retrieval of author number-->
      <xsl:variable name="prefauth" select="position()" />
      <!--Add a comma if 2nd+ author -->
      <xsl:if test="$prefauth &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:choose>
        <!-- if first author, don't append a number -->
        <xsl:when test="$prefauth = 1">
          <xsl:text>au=</xsl:text>
        </xsl:when>
        <!-- if 2nd or later author, append a number -->
        <xsl:when test="$prefauth &gt; 1">
          <xsl:value-of select="concat('au',$prefauth, '=')"/>
        </xsl:when>
      </xsl:choose>

      <xsl:text>"</xsl:text>
      <!--Grabbing only specific children nodes, as affiliation nodes can also show up within author nods -->
      <!--If firstname/surname:-->     
      <xsl:if test="firstname">
        <xsl:value-of select="firstname"/>
      </xsl:if>
      <xsl:if test="surname">
        <xsl:text> </xsl:text><xsl:value-of select="surname"/>
      </xsl:if>
      <!--If othername:-->
      <xsl:if test="othername">
        <xsl:value-of select="othername"/>
      </xsl:if>
      <xsl:text>"</xsl:text>
    </xsl:for-each>

    <!--Gather Author Affiliation(s):-->
    <!--Test to see if there's not a date, not an affiliation OUTSIDE author, not an affiliation INSIDE author -->
    <xsl:choose>
      <!--If there's nothing, just close the tag and you're good-->
      <xsl:when test="not(prefaceinfo//affiliation) and not(prefaceinfo/date)">
        <xsl:text>]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- There can be multiple affiliations and multiple jobtitles or orgnames within
             each other. We need for-each's to select potentially multiple of all of these -->
        <xsl:text>, auaffil="</xsl:text>         
        <!--For each child affilation tag in prefaceinfo-->
        <xsl:for-each select="prefaceinfo//affiliation">
          <!--Commas for multiple jobtitle/orgname nodes within a single affiliation node-->
          <xsl:value-of select="*" separator=", "/>
          <!-- Comma Formatting For things separator doesn't get-->
          <xsl:if test="not( position() = last() )">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
        <!--If Date, put it in:-->
        <xsl:if test="prefaceinfo//date">
          <!--only use a comma if there were preceding affiliation things-->
          <xsl:if test="prefaceinfo//affiliation">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:value-of select="prefaceinfo//date"/>
        </xsl:if>
        <!-- close off the asciidioc tag -->
        <xsl:text>"]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:text>&#xa;== </xsl:text>
    <xsl:value-of select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Section-level                                                         -->
  <!-- ===================================================================== -->

  <!-- Chunk output by any section-level division element, but only in chapters and appendices -->
  <xsl:template match="chapter/section | appendix/section | sect1">
    <xsl:if test="$chunk-sections != 'false'">
      <xsl:variable name="sectiondocname">
        <xsl:value-of select="util:section-doc-name(self::node())"/>
      </xsl:variable>

      <!-- Determine chapter-level directory name without extension -->
      <xsl:variable name="chapterdirname">
        <xsl:value-of select="substring-before(util:getFilename(base-uri(parent::node())), '.')"/>
      </xsl:variable>

      <!-- Include the chapter-doc in the book-doc -->
      <xsl:value-of select="util:carriage-returns(1)"/>
      <xsl:text>include::</xsl:text>
      <xsl:value-of select="$sectiondocname"/>
      <xsl:text>[]&#xa;</xsl:text>

      <!-- Create the chapter-doc -->
      <xsl:result-document href="{$chapterdirname}/{$sectiondocname}">
        <xsl:call-template name="process-id"/>
        <xsl:sequence select="string-join ((for $i in (1 to count (ancestor::section | ancestor::simplesect) + 3) return '='),'')"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="title"/>
        <xsl:value-of select="util:carriage-returns(2)"/>

        <!-- Selecting . would result in infinite loop -->
        <xsl:apply-templates select="*[not(self::title)]"/>

        <!-- The file must end with an empty line or otherwise the title of next section will be damaged -->
        <xsl:value-of select="util:carriage-returns(2)"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- Determine the file name of the section doc -->
  <xsl:function name="util:section-doc-name">
    <xsl:param name="node"/>

    <xsl:variable name="sectionid">
      <xsl:value-of select="$node/@xml:id"/>
    </xsl:variable>

    <xsl:variable name="sectionbasename">
      <xsl:value-of select="replace($sectionid, '\.', '-')"/>
    </xsl:variable>

    <!-- Output to per-chapter sub-directory -->
    <xsl:value-of select="concat('section-', $sectionbasename, '.asciidoc')"/>
  </xsl:function>

  <xsl:template match="section | simplesect">
    <xsl:call-template name="process-id"/>
    <xsl:sequence select="string-join ((for $i in (1 to count (ancestor::section | ancestor::simplesect) + 3) return '='),'')"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="title"/>

    <xsl:if test="empty(title)">
      <xsl:message>Empty section title <xsl:value-of select="@xml:id"/><xsl:value-of select="id"/>&#10;</xsl:message>
    </xsl:if>

    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <xsl:template match="sect1">
    <!-- If sect1 title is "References," override special Asciidoc section macro -->
    <xsl:if test="title = 'References'">
      <xsl:text>[sect2]</xsl:text>
      <xsl:value-of select="util:carriage-returns(1)"/>
    </xsl:if>
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;=== </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <xsl:template match="sect2">
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;==== </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <xsl:template match="sect3">
    <xsl:call-template name="process-id"/>
    <xsl:text>&#xa;==== </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:value-of select="util:carriage-returns(2)"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </xsl:template>

  <!-- Use passthrough for sect4 and sect5, as there is no AsciiDoc markup/formatting for these -->
  <xsl:template match="sect4|sect5">
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
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
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
  </xsl:template>

  <!-- Use passthrough for bibliography -->
  <xsl:template match="bibliography">
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
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
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
  </xsl:template>

  <!-- Use passthrough for reference sections -->
  <xsl:template match="refentry">
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
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
    <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="title/text()">
    <xsl:value-of select="replace(., '\n\s+', ' ', 'm')"/>
  </xsl:template>

  <xsl:template match="*" mode="title">
    <xsl:if test="title">
      <xsl:text>.</xsl:text>
      <xsl:apply-templates select="title"/>
      <xsl:value-of select="util:carriage-returns(1)"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

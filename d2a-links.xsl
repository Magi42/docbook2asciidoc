<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Links                                                                   -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- ===================================================================== -->
  <!-- xref                                                                  -->
  <!-- ===================================================================== -->
  <xsl:template match="xref">
    <xsl:text>&#xE801;&#xE801;</xsl:text>

    <xsl:variable name="linkend">
      <xsl:value-of select="@linkend"/>
    </xsl:variable>

    <xsl:variable name="linkend-filename">
      <xsl:call-template name="id-chunk">
        <xsl:with-param name="id" select="$linkend"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- <xsl:message>Linkend-filename: <xsl:value-of select="$linkend"/> is <xsl:value-of select="$linkend-filename"/></xsl:message> -->

    <xsl:variable name="current-filename">
      <xsl:call-template name="id-chunk">
        <xsl:with-param name="id" select="(ancestor::*[@xml:id!=''])[1]/@xml:id"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- Chunk filename is only needed if it's different from the current file -->
    <xsl:choose>
      <xsl:when test="$linkend-filename != $current-filename">
        <xsl:call-template name="generate-interdoc-xref">
          <xsl:with-param name="linkend-filename" select="$linkend-filename"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>In same file: <xsl:value-of select="$linkend"/> is in <xsl:value-of select="$linkend-filename"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>

    <!-- And then the actual ID -->
    <xsl:text>#</xsl:text>
    <xsl:call-template name="generate-xref-urifragment">
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>

    <!-- Include the title -->
    <xsl:text>,"</xsl:text>
    <xsl:value-of select="//*[@xml:id=$linkend]/title"/>

    <xsl:text>"&#xE802;&#xE802;</xsl:text>
  </xsl:template>

  <!-- Extension hook to allow modifying all inter-document cross-references -->
  <xsl:template name="generate-interdoc-xref">
    <xsl:param name="linkend-filename"/>
    <xsl:value-of select="$linkend-filename"/>
  </xsl:template>

  <!-- Extension hook to allow modifying URI fragment of xrefs -->
  <xsl:template name="generate-xref-urifragment">
    <xsl:param name="linkend"/>
    <xsl:value-of select="$linkend"/>
  </xsl:template>

  <!-- id-chunk
       Determines the file name by ID.
       Uses the same logic as when generating file names in d2a-divisions.xsl. -->
  <xsl:template name="id-chunk">
    <xsl:param name="id"/>

    <!-- Find the URI of the file in which the linkend ID resides -->
    <xsl:variable name="sourceuri">
      <xsl:value-of select="base-uri(//*[@xml:id=$id])"/>
    </xsl:variable>

    <!-- If chunking, start with path to the chapter chunking directory -->
    <!-- TODO: Maybe this should be handled in an overridable generator,
               not sure if everything works if chunking is disabled. -->
    <xsl:if test="$chunk-sections != 'false'">
      <xsl:call-template name="generate-chapter-dirname">
        <xsl:with-param name="original-basename" select="substring-before(util:getFilename($sourceuri), '.')"/>
      </xsl:call-template>

      <xsl:text>/</xsl:text>
    </xsl:if>

    <!-- Determine base file name of the chapter file -->
    <xsl:variable name="chapterbasefilename">
        <xsl:call-template name="generate-chapter-xref-basename">
          <xsl:with-param name="filename" select="substring-before(util:getFilename($sourceuri), '.')"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="chunkpath">
      <xsl:choose>
        <!-- Is it inside a section chunk? -->
        <xsl:when test="$chunk-sections != 'false' and exists(//section/descendant-or-self::*[@xml:id=$id])">
          <xsl:variable name="sectionid">
            <!-- Chunked by highest-level section; get its ID -->
            <!-- Apparently the ancestors are ordered from root node, hence [1] and not [last()] -->
            <xsl:value-of select="(//*[@xml:id=$id]/ancestor-or-self::section)[1]/@xml:id"/>
          </xsl:variable>

          <xsl:variable name="sectionbasename">
            <xsl:call-template name="generate-section-basename">
              <xsl:with-param name="sectionid" select="$sectionid"/>
            </xsl:call-template>
          </xsl:variable>

          <!-- File extension could be given, but is not needed -->
          <xsl:value-of select="$sectionbasename"/>
        </xsl:when>

        <!-- Not inside a section chunk - must be in chapter-level division file or similar -->
        <xsl:otherwise>
          <xsl:value-of select="concat($chapterbasefilename, '.asciidoc')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- <xsl:message><xsl:value-of select="$chunkpath"/></xsl:message>  -->
    <xsl:value-of select="$chunkpath"/>
  </xsl:template>

  <xsl:template name="generate-chapter-xref-basename">
    <xsl:param name="filename"/>

    <xsl:value-of select="$filename"/>
  </xsl:template>

  <xsl:template name="generate-section-basename">
    <xsl:param name="sectionid"/>

    <xsl:value-of select="concat('section-', replace($sectionid, '\.', '-'))"/>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- External links                                                        -->
  <!-- ===================================================================== -->

  <xsl:template match="link" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:choose>
      <!-- Hyperlink -->
      <xsl:when test="@xlink:href">
        <xsl:if test="@xlink:href != text()">
          <xsl:text>link:</xsl:text>
        </xsl:if>
        <xsl:value-of select="@xlink:href"/>
        <xsl:if test="@xlink:href != text()">
          <xsl:text>[</xsl:text>
          <xsl:value-of select="normalize-space(text())"/>
          <xsl:text>]</xsl:text>
        </xsl:if>
      </xsl:when>

      <!-- AsciiDoc link -->
      <xsl:otherwise>
        <xsl:text>&#xE801;&#xE801;</xsl:text>
        <xsl:value-of select="@linkend" />
        <xsl:text>,</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&#xE802;&#xE802;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ulink">
    <xsl:text>link:$$</xsl:text>
    <xsl:value-of select="@url" />
    <xsl:text>$$[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="email">
    <xsl:text>pass:[</xsl:text>
    <xsl:element name="email">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="ulink/text()">
    <xsl:value-of select="replace(., '\n\s+', ' ', 'm')"/>
  </xsl:template>
</xsl:stylesheet>

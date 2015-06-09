<?xml version="1.0" encoding="utf-8"?>

<!-- ======================================================================= -->
<!-- Code blocks                                                             -->
<!--                                                                         -->
<!-- ======================================================================= -->

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:util="http://github.com/oreillymedia/docbook2asciidoc/"
  xpath-default-namespace="http://docbook.org/ns/docbook"
  exclude-result-prefixes="util">

  <!-- Special handling for text inside code block that will be converted as Asciidoc, 
       to make sure special characters are not escaped.-->
  <xsl:template match="text()" mode="code">
    <xsl:value-of select=".[not(parent::title)]" disable-output-escaping="yes"></xsl:value-of>
  </xsl:template>

  <xsl:template match="example">
    <xsl:choose>
      <!-- When example code contains callouts -->
      <xsl:when test="//co">
        <xsl:choose>
          <!-- When example code contains other inlines besides callouts, output as Docbook passthrough -->
          <xsl:when test="descendant::*[*[not(self::co)]]">
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
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- When example code is in a different section than corresponding calloutlist,
               output as Docbook passthrough-->
          <xsl:when test="parent::node() != */co/id(@linkends)/parent::calloutlist/parent::node()">
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
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- When example code contains only callout inlines, output as Asciidoc -->
          <xsl:otherwise>
            <xsl:call-template name="process-id"/>
            <xsl:apply-templates select="." mode="title"/>
            <xsl:text>====&#xa;</xsl:text>

            <!-- Preserve non-empty "language" attribute if present -->
            <xsl:if test="@language != ''">
              <xsl:text>[source, </xsl:text>
              <xsl:value-of select="@language"/>
              <xsl:text>]</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>

            <xsl:choose>
              <!-- Must format as a [listing block] for proper AsciiDoc processing, if programlisting text contains 4 hyphens in a row -->
              <xsl:when test="matches(., '----')">
                <xsl:text>[listing]</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()"><xsl:value-of select="util:carriage-returns(1)"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="util:carriage-returns(2)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <xsl:otherwise>
                <xsl:text>----</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>----</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()"><xsl:value-of select="util:carriage-returns(1)"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="util:carriage-returns(2)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>====&#xa;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- When example code doesn't contain callouts -->
      <xsl:otherwise>
        <xsl:choose>
          <!-- When example code contains inline elements, output as Docbook passthrough -->
          <xsl:when test="example[descendant::*[*]]">
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
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- Otherwise output as Asciidoc -->
          <xsl:otherwise>
            <xsl:call-template name="process-id"/>
            <xsl:apply-templates select="." mode="title"/>
            <xsl:text>====&#xa;</xsl:text>

            <!-- Preserve non-empty "language" attribute if present -->
            <xsl:if test="@language != ''">
              <xsl:text>[source, </xsl:text>
              <xsl:value-of select="@language"/>
              <xsl:text>]</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>
            <xsl:choose>

              <!-- Must format as a [listing block] for proper AsciiDoc processing, if programlisting text contains 4 hyphens in a row -->
              <xsl:when test="matches(., '----')">
                <xsl:text>[listing]</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()"><xsl:value-of select="util:carriage-returns(1)"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="util:carriage-returns(2)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>&#xa;----&#xa;</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>&#xa;----&#xa;</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()"><xsl:value-of select="util:carriage-returns(1)"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="util:carriage-returns(2)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>====&#xa;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Listings                                                                -->
  <!-- ======================================================================= -->

  <xsl:template match="programlisting | screen">
    <xsl:choose>
      <!-- Contains child <co> elements -->
      <xsl:when test="co">
        <xsl:choose>
          <!-- Use Docbook passthrough when code block contains other child elements besides <co>-->
          <xsl:when test="*[not(self::co) and not(indexterm)]">
            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>+</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- Use Docbook passthrough when corresponding calloutlist isn't in same section -->
          <xsl:when test="not(self::*/parent::node() = co/id(@linkends)/parent::calloutlist/parent::node())">
            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>+</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- Use Docbook passthrough when code block contains indexterms and you want to keep them -->
          <xsl:when test="indexterm and $strip-indexterms='false'">
            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>+</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- Otherwise output as Asciidoc -->
          <xsl:otherwise>
            <xsl:value-of select="util:carriage-returns(1)"/>
            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>+</xsl:text><xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>

            <!-- Preserve non-empty "language" attribute if present -->
            <xsl:if test="@language != ''">
              <xsl:text>[source, </xsl:text>
              <xsl:value-of select="@language"/>
              <xsl:text>]</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>

            <xsl:choose>
              <!-- Must format as a [listing block] for proper AsciiDoc processing, if programlisting text contains 4 hyphens in a row -->
              <xsl:when test="matches(., '----')">
                <xsl:text>[listing]</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()">
                    <xsl:value-of select="util:carriage-returns(1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="util:carriage-returns(2)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <xsl:otherwise>
                <xsl:text>&#xa;----&#xa;</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>&#xa;----&#xa;</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()">
                    <xsl:value-of select="util:carriage-returns(1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="util:carriage-returns(2)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- No child co elements -->
      <xsl:otherwise>
        <xsl:choose>
          <!-- Use Docbook passthrough when code block has inlines -->
          <xsl:when test="*[not(self::indexterm)]">
            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>&#xa;+</xsl:text>
            </xsl:if>
            <xsl:value-of select="util:carriage-returns(1)"/>
            <xsl:text>++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
          </xsl:when>

          <!-- Use Docbook passthrough when code block contains indexterms and you want to keep them -->
          <xsl:when test="indexterm and $strip-indexterms='false'">
            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>+</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>
            <xsl:text>++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
          </xsl:when>

          <!-- Output Asciidoc -->
          <xsl:otherwise>
            <!-- TODO Removing this newline seems to cause some odd trouble. -->
            <xsl:value-of select="util:carriage-returns(1)"/>

            <xsl:if test="ancestor::listitem and preceding-sibling::element()">
              <xsl:text>+</xsl:text><xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>

            <!-- Preserve non-empty "language" attribute if present -->
            <xsl:if test="@language != ''">
              <xsl:text>[source, </xsl:text>
              <xsl:value-of select="@language"/>
              <xsl:text>]</xsl:text>
              <xsl:value-of select="util:carriage-returns(1)"/>
            </xsl:if>

            <xsl:choose>
              <!-- Must format as a [listing block] for proper AsciiDoc processing, if programlisting text contains 4 hyphens in a row -->
              <xsl:when test="matches(., '----')">
                <xsl:text>[listing]</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>....</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()">
                    <xsl:value-of select="util:carriage-returns(1)"/>
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="util:carriage-returns(2)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <xsl:otherwise>
                <xsl:text>----</xsl:text>
                <xsl:value-of select="util:carriage-returns(1)"/>

                <!-- This apply-templates calls on special "code" mode templates for text() and <co> elements.
                     Allows disable-output-escaping to be used on text(), while still using apply-templates to
                     process child <co> elements. -->
                <xsl:apply-templates mode="code"/>
                <xsl:value-of select="util:carriage-returns(1)"/>
                <xsl:text>----</xsl:text>
                <xsl:choose>
                  <xsl:when test="ancestor::listitem and preceding-sibling::element()">
                    <xsl:value-of select="util:carriage-returns(1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="util:carriage-returns(2)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- Callouts                                                                -->
  <!-- ======================================================================= -->

  <!-- <co> element -->
  <xsl:template match="co" mode="code">
    <xsl:variable name="curr" select="@id"/>
    <xsl:text>&#xE801;</xsl:text>
    <xsl:value-of select="count(//calloutlist/callout[@arearefs=$curr]/preceding-sibling::callout)+1"/>
    <xsl:text>&#xE802;</xsl:text>
  </xsl:template>

  <!-- Calloutlist -->
  <xsl:template match="calloutlist">
    <xsl:choose>
      <!-- Calloutlist points to an example -->
      <xsl:when test="callout/id(@arearefs)/ancestor::example">
        <xsl:choose>
          <!-- When corresponding code block has inlines (besides co) and will be output as Docbook passthrough,
               also output calloutlist as Docbook passthrough-->
          <xsl:when test="callout/id(@arearefs)/parent::*[*[not(self::co)]]">
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- When corresponding code block isn't in same section as calloutlist and will be output as Docbook passthrough,
               also output calloutlist as Docbook passthrough.-->
          <xsl:when test="callout/id(@arearefs)/parent::*/parent::example/parent::node() != self::calloutlist/parent::node()">
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- Otherwise output as Asciidoc -->
          <xsl:otherwise>
            <xsl:for-each select="callout">
              <xsl:text>&#xa;&#xE801;</xsl:text>
              <xsl:value-of select="position()"/>&#xE802; <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:if test="calloutlist">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- Calloutlist points to a regular code block (not example) -->
      <xsl:otherwise>
        <xsl:choose>
          <!-- When corresponding code block has inlines (besides co) and will be output as Docbook passthrough,
               also output calloutlist as Docbook passthrough-->
          <xsl:when test="callout/id(@arearefs)/parent::*[*[not(self::co)]]">
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- When corresponding code block isn't in same section as calloutlist and will be output as Docbook passthrough,
               also output calloutlist as Docbook passthrough.-->
          <xsl:when test="callout/id(@arearefs)/parent::*/parent::node() != self::calloutlist/parent::node()">
            <xsl:text>&#xa;++++++++++++++++++++++++++++++++++++++&#xa;</xsl:text>
            <xsl:copy-of select="."/>
            <xsl:text>++++++++++++++++++++++++++++++++++++++&#xa;&#xa;</xsl:text>
          </xsl:when>

          <!-- Otherwise output as Asciidoc -->
          <xsl:otherwise>
            <xsl:for-each select="callout">
              <xsl:text>&#xE801;</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text>&#xE802; </xsl:text>
              <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:if test="calloutlist">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:ref="http://www.gnome.org/~shaunm/mallard/reference"
		exclude-result-prefixes="rng ref"
		version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<ref:title>Documenting RELAX NG Schemes</ref:title>


<!-- == rngdoc.toplevel_element == -->

<ref:refname>rngdoc.toplevel_element</ref:refname>
<ref:refpurpose>The top-level element in the generated DocBook</ref:refpurpose>
<ref:para>
  The <ref:parameter>rngdoc.toplevel_element</ref:parameter> parameter
  defines the top-level element used in the generated DocBook.  Allowed
  values are
  <ref:literal>'article'</ref:literal>,
  <ref:literal>'appendix'</ref:literal>,
  <ref:literal>'chapter'</ref:literal>,
  <ref:literal>'reference'</ref:literal>, and
  <ref:literal>'section'</ref:literal>.
  The default is <ref:literal>'section'</ref:literal>.  This may also be
  set by the <ref:xmltag role="xmlpi">rngdoc.toplevel_element</ref:xmltag>
  processing instruction in the source RELAX-NG file.
</ref:para>

<xsl:param name="rngdoc.toplevel_element">
  <xsl:choose>
    <xsl:when test="processing-instruction('rngdoc.toplevel_element')">
      <xsl:value-of select="processing-instruction('rngdoc.toplevel_element')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'section'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- == Matched Templates == -->

<!-- = /rng:grammar = -->
<xsl:template match="/rng:grammar">
  <xsl:variable name="toplevel_element">
    <xsl:choose>
      <xsl:when test="
		$rngdoc.toplevel_element = 'article'   or
		$rngdoc.toplevel_element = 'appendix'  or
		$rngdoc.toplevel_element = 'chapter'   or
		$rngdoc.toplevel_element = 'reference' or
		$rngdoc.toplevel_element = 'section'   ">
	<xsl:value-of select="$rngdoc.toplevel_element"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">
	  <xsl:text>Unsupported value of $rngdoc.toplevel_element: </xsl:text>
	  <xsl:value-of select="$rngdoc.toplevel_element"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="{$toplevel_element}">
    <xsl:apply-templates select="ref:title"/>
    <xsl:apply-templates select="rng:start"/>
    <xsl:apply-templates select="rng:define"/>
    <xsl:apply-templates select="rng:div"/>
  </xsl:element>
</xsl:template>

<!-- = rng:div = -->
<xsl:template match="rng:div">
  <section>
    <xsl:if test="@ref:role">
      <xsl:attribute name="role">
	<xsl:value-of select="@ref:role"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="ref:title"/>
    <xsl:apply-templates select="ref:subtitle"/>
    <xsl:apply-templates mode="refentry.mode" select="rng:start"/>
    <xsl:apply-templates mode="refentry.mode" select="rng:define"/>
    <xsl:apply-templates mode="refentry.mode" select="rng:div"/>
  </section>
</xsl:template>

<!-- = rng:define = -->
<xsl:template mode="refentry.mode" match="rng:define">
  <xsl:choose>
    <xsl:when test="ref:refname">
      <refentry id="{ref:refname}" role="define">
	<refnamediv>
	  <xsl:apply-templates select="ref:refname"/>
	  <xsl:apply-templates select="ref:refpurpose"/>
	</refnamediv>
	<xsl:apply-templates select="
	    ref:*[local-name(.) != 'refname' and local-name(.) != 'refpurpose']"/>
      </refentry>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<!-- = rng:element = -->
<xsl:template mode="refentry.mode" match="rng:element">
</xsl:template>

<!-- = rng:include = -->
<xsl:template match="rng:include">
</xsl:template>

<!-- = ref:title = -->
<xsl:template match="ref:title">
  <title>
    <xsl:apply-templates/>
  </title>
</xsl:template>

<!-- = ref:subtitle = -->
<xsl:template match="ref:subtitle">
  <title>
    <xsl:apply-templates/>
  </title>
</xsl:template>

<!-- = ref:refname = -->
<xsl:template match="ref:refname">
  <refname>
    <xsl:apply-templates/>
  </refname>
</xsl:template>

<!-- = ref:refpurpose = -->
<xsl:template match="ref:refpurpose">
  <refentry>
    <xsl:apply-templates/>
  </refentry>
</xsl:template>

</xsl:stylesheet>
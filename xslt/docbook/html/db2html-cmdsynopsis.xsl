<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:doc="http://www.gnome.org/~shaunm/xsldoc"
		exclude-result-prefixes="doc"
                version="1.0">

<doc:title>Command Synopses</doc:title>

<!-- == db2html.cmdsynopsis.sepchar ======================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.cmdsynopsis.sepchar</name>
  <description>
    The default value for the <parameter>sepchar</parameter> paramter
  </description>
</parameter>

<xsl:param name="db2html.cmdsynopsis.sepchar" select="' '"/>


<!-- == db2html.arg.choice ================================================= -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.arg.choice</name>
  <description>
    The default value of the <parameter>choice</parameter> paramter
    for <xmltag>arg</xmltag> elements
  </description>
</parameter>

<xsl:param name="db2html.arg.choice" select="'opt'"/>


<!-- == db2html.arg.rep ==================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.arg.rep</name>
  <description>
    The default value of the <parameter>rep</parameter> paramter
    for <xmltag>arg</xmltag> elements
  </description>
</parameter>

<xsl:param name="db2html.arg.rep" select="'norepeat'"/>


<!-- == db2html.group.choice =============================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.group.choice</name>
  <description>
    The default value of the <parameter>choice</parameter> paramter
    for <xmltag>group</xmltag> elements
  </description>
</parameter>

<xsl:param name="db2html.group.choice" select="'opt'"/>


<!-- == db2html.group.rep ================================================== -->

<parameter xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.group.rep</name>
  <description>
    The default value of the <parameter>rep</parameter> paramter
    for <xmltag>group</xmltag> elements
  </description>
</parameter>

<xsl:param name="db2html.group.rep" select="'norepeat'"/>


<!-- == db2html.cmdsynopsis ================================================ -->

<template xmlns="http://www.gnome.org/~shaunm/xsldoc">
  <name>db2html.cmdsynopsis</name>
  <description>
    Process a <xmltag>cmdsynopsis</xmltag> element
  </description>
  <parameter>
    <name>sepchar</name>
    <description>
      The character that separates commands and arguments
    </description>
  </parameter>
  <para>
    This template is called for all <xmltag>cmdsynopsis</xmltag>
    elements.  Child elements are processed with the mode
    <mode>db2html.cmdsynopsis.mode</mode>.  You may override
    templates in this mode to customize the behavior of
    elements inside <xmltag>cmdsynopsis</xmltag>.
  </para>
  <para>
    The <parameter>sepchar</parameter> parameter is passed to the templates
    in <mode>db2html.cmdsynopsis.mode</mode>.  If you override a template
    in this mode, you should pass this parameter through as well.
  </para>
</template>

<xsl:template name="db2html.cmdsynopsis">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="@sepchar">
	<xsl:value-of select="@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <div class="cmdsynopsis">
    <xsl:call-template name="db2html.anchor"/>
    <xsl:for-each select="command | arg | group | sbr">
      <xsl:if test="position != 1">
	<xsl:value-of select="$sepchar"/>
      </xsl:if>
      <xsl:apply-templates mode="db2html.cmdsynopsis.mode">
	<xsl:with-param name="sepchar" select="$sepchar"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:apply-templates mode="db2html.cmdsynopsis.mode"
			 select="synopfragment">
      <xsl:with-param name="sepchar" select="$sepchar"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="cmdsynopsis">
  <xsl:call-template name="db2html.cmdsynopsis"/>
</xsl:template>


<!-- == db2html.cmdsynopsis.mode =========================================== -->

<mode xmlns="http://www.gnome.org/~shaunm/xsldoc">>
  <name>db2html.cmdsynopsis.mode</name>
  <FIXME/>
</mode>

<!-- = arg = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="arg">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
	<xsl:value-of select="ancesotr::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="choice">
    <xsl:choose>
      <xsl:when test="@choice">
	<xsl:value-of select="@choice"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.arg.choice"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="rep">
    <xsl:choose>
      <xsl:when test="@rep">
	<xsl:value-of select="@rep"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.arg.rep"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <span class="arg-punc">
    <xsl:choose>
      <xsl:when test="$choice = 'plain'"/>
      <xsl:when test="$choice = 'req'">
	<xsl:text>{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>[</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <span class="arg">
      <xsl:apply-templates mode="db2html.cmdsynopsis.mode">
	<xsl:with-param name="sepchar" select="$sepchar"/>
      </xsl:apply-templates>
    </span>
    <xsl:if test="$rep = 'repeat'">
      <xsl:text>...</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$choice = 'plain'"/>
      <xsl:when test="$choice = 'req'">
	<xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<!-- = group = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="group">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
	<xsl:value-of select="ancesotr::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="choice">
    <xsl:choose>
      <xsl:when test="@choice">
	<xsl:value-of select="@choice"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.group.choice"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="rep">
    <xsl:choose>
      <xsl:when test="@rep">
	<xsl:value-of select="@rep"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.group.rep"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <span class="group-punc">
    <xsl:choose>
      <xsl:when test="$choice = 'plain'">
	<xsl:text>(</xsl:text>
      </xsl:when>
      <xsl:when test="$choice = 'req'">
	<xsl:text>{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>[</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <span class="group">
      <xsl:for-each select="*">
	<xsl:if test="local-name(.) = 'arg' and position() != 1">
	  <xsl:value-of select="concat($sepchar, '|', $sepchar"/>
	</xsl:if>
	<xsl:apply-templates mode="db2html.cmdsynopsis.mode" select=".">
	  <xsl:with-param name="sepchar" select="$sepchar"/>
	</xsl:apply-templates>
      </xsl:for-each>
    </span>
    <xsl:choose>
      <xsl:when test="$choice = 'plain'">
	<xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="$choice = 'req'">
	<xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$rep = 'repeat'">
      <xsl:text>...</xsl:text>
    </xsl:if>
  </span>
</xsl:template>

<!-- = sbr = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="sbr">
  <br class="sbr"/>
</xsl:template>

<!-- = synopfragment = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="synopfragment">
  <xsl:param name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor::cmdsynopsis[1][@sepchar]">
	<xsl:value-of select="ancesotr::cmdsynopsis[1]/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$db2html.cmdsynopsis.sepchar"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <div class="synopfragment">
    <xsl:call-template name="db2html.anchor"/>
    <i><xsl:call-template name="db2html.label"/></i>
    <xsl:apply-templates mode="db2html.cmdsynopsis.mode">
      <xsl:with-param name="sepchar" select="$sepchar"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- = synopfragmentref = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="synopfragmentref">
  <xsl:call-template name="db2html.xref"/>
</xsl:template>

<!-- = node() = -->
<xsl:template mode="db2html.cmdsynopsis.mode" match="node()">
  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>

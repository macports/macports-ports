<?xml version="1.0" ?>
<!-- this stylesheet ajusts menu item accelerators:
     - Control-XX to Command-XX
     - Command-, for preferences
     - Command-? for user manual
     
     accelerators names are found in gtk/source/gtk+/gdk/gdkkeysyms-compat.h
  -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@modifiers[. = 'GDK_CONTROL_MASK']">
		<xsl:attribute name="modifiers">GDK_META_MASK</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="accelerator[preceding-sibling::*[1][property[@name = 'stock_id' and . = 'gtk-preferences']]]">
          <accelerator key="comma" modifiers="GDK_META_MASK"/>
	</xsl:template>
	
	<xsl:template match="object[property[@name='stock_id' and . ='gtk-help']]">
	  <xsl:copy>
	  	<xsl:apply-templates select="@*|node()"/>
	  </xsl:copy>
          <accelerator key="question" modifiers="GDK_META_MASK"/>
	</xsl:template>

</xsl:stylesheet>


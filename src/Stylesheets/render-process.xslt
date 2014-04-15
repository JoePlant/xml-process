<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dotml="http://www.martin-loetzsch.de/DOTML" >
	
	<xsl:output method="xml" indent="yes" />
	
	<xsl:param name='direction'>LR</xsl:param>
	
	<xsl:include href='include-graphs-colours.xslt'/>
	
	<xsl:template match="/" >
		<xsl:apply-templates select="/ProcessFlow"/>
	</xsl:template>
	
	<xsl:template match="/ProcessFlow">
		<dotml:graph file-name="flow" label="{@name}" rankdir="{$direction}" fontname="{$fontname}" fontsize="{$font-size-h1}" labelloc='t' >			
			<xsl:apply-templates select='InputsView' mode='node'/>
			<xsl:apply-templates select='OutputsView' mode='node'/>
			<xsl:apply-templates select='ConsumablesView' mode='node'/>			
			<xsl:apply-templates select='WasteView' mode='node'/>
			
			<xsl:apply-templates select='AreasView' mode='node'/>
			
			<xsl:apply-templates select='InputsView' mode='link'/>
			<xsl:apply-templates select='OutputsView' mode='link'/>
			<xsl:apply-templates select='ConsumablesView' mode='link'/>
			<xsl:apply-templates select='WasteView' mode='link'/>
			
			<xsl:apply-templates select='FlowsView' mode='link'/>
			<xsl:apply-templates select='LinksView' mode='link'/>
		</dotml:graph>
	</xsl:template>
	
	<xsl:template match='InputsView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='source'>
				<xsl:apply-templates select='*' mode='node'>
					<xsl:with-param name='color' select='$input-color'/>
					<xsl:with-param name='bg-color' select='$input-color-bg'/>
					<xsl:with-param name='font-color' select='$input-color-font'/>
				</xsl:apply-templates>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>

	<xsl:template match='ConsumablesView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='source'>
				<xsl:apply-templates select='*' mode='node'>
					<xsl:with-param name='color' select='$consumable-color'/>
					<xsl:with-param name='bg-color' select='$consumable-color-bg'/>
					<xsl:with-param name='font-color' select='$consumable-color-font'/>
				</xsl:apply-templates>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>	

	<xsl:template match='WasteView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='sink'>
				<xsl:apply-templates select='*' mode='node'>
					<xsl:with-param name='color' select='$waste-color'/>
					<xsl:with-param name='bg-color' select='$waste-color-bg'/>
					<xsl:with-param name='font-color' select='$waste-color-font'/>
				</xsl:apply-templates>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>

	<xsl:template match='OutputsView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='sink'>
				<xsl:apply-templates select='*' mode='node'>
					<xsl:with-param name='color' select='$output-color'/>
					<xsl:with-param name='bg-color' select='$output-color-bg'/>
					<xsl:with-param name='font-color' select='$output-color-font'/>
				</xsl:apply-templates>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match='*' mode='node'>
		<xsl:param name='color' select='$default-color'/>
		<xsl:param name='bg-color' select='$default-color-bg'/>
		<xsl:param name='font-color' select='$default-color-font'/>
		<xsl:choose> 
			<xsl:when test='string-length(@id) > 0 and */@id'>
			<!--
				<dotml:cluster id='{@id}' 
					label='{@name}' labeljust='l' labelloc="t" 
					style='filled' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
					fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}">  
					-->
					<xsl:apply-templates select='*' mode='node'/>
					<!--
				</dotml:cluster>
				-->
			</xsl:when>
			<xsl:when test='@id'>
				<xsl:call-template name='render-node'>	
					<xsl:with-param name='color' select='$color'/>
					<xsl:with-param name='bg-color' select='$bg-color'/>
					<xsl:with-param name='font-color' select='$font-color'/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test='*/@id'>
				<xsl:apply-templates select='*' mode='node'/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match='*' mode='link'>
		<xsl:choose> 
			<xsl:when test='@to and @from'>
				<xsl:call-template name='render-link'/>
			</xsl:when>
			<xsl:when test='*'>
				<xsl:apply-templates select='*' mode='link'/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name='render-node'>
		<xsl:param name='color' select='$default-color'/>
		<xsl:param name='bg-color' select='$default-color-bg'/>
		<xsl:param name='font-color' select='$default-color-font'/>
		<xsl:variable name='node' select='.'/>
		<dotml:node id='{@id}' style="filled" shape="box" label='{@name}' fillcolor='{$bg-color}' color="{$color}" 
		fontname="{$fontname}" fontsize="{$font-size-h2}" fontcolor="{$font-color}" />
	</xsl:template>

	<xsl:template name='render-link'>
		<xsl:variable name='node' select='.'/>
		<xsl:comment><xsl:value-of select='name()'/>: <xsl:value-of select='@name'/></xsl:comment>
		<xsl:variable name='style'>
			<xsl:choose>
				<xsl:when test="name()='Flow'">solid</xsl:when>
				<xsl:when test="name()='Link'">dotted</xsl:when>
				<xsl:otherwise>dashed</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<dotml:edge from="{@from}" to="{@to}" color="{$link-color}" style="{$style}" fontname="{$fontname}" fontcolor="{$link-color}" fontsize="{$font-size-h2}" />
	</xsl:template>

</xsl:stylesheet>

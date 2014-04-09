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
		</dotml:graph>
	</xsl:template>
	
	<xsl:template match='InputsView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='source'>
				<xsl:apply-templates select='*' mode='node'/>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>

	<xsl:template match='ConsumablesView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='source'>
				<xsl:apply-templates select='*' mode='node'/>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>	

	<xsl:template match='WasteView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='sink'>
				<xsl:apply-templates select='*' mode='node'/>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>

	<xsl:template match='OutputsView' mode='node'>
		<xsl:if test='*'>
			<dotml:sub-graph rank='sink'>
				<xsl:apply-templates select='*' mode='node'/>
			</dotml:sub-graph>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match='*' mode='node'>
		<xsl:choose> 
			<xsl:when test='string-length(@id) > 0 and */@id'>
				<dotml:cluster id='{@id}' 
					label='{@name}' labeljust='l' labelloc="t" 
					style='filled' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
					fontname="{$fontname}" fontcolor="{$focus-color}" fontsize="{$font-size-h2}"> 
					<xsl:apply-templates select='*' mode='node'/>
				</dotml:cluster>
			</xsl:when>
			<xsl:when test='@id'>
				<xsl:call-template name='render-node'/>
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
		<xsl:variable name='node' select='.'/>
		<dotml:node id='{@id}' style="solid" shape="box" label='{@name}' fillcolor='{$focus-bgcolor}' color="{$focus-color}" 
		fontname="{$fontname}" fontsize="{$font-size-h2}" fontcolor="{$focus-color}" />
	</xsl:template>

	<xsl:template name='render-link'>
		<xsl:variable name='node' select='.'/>
		<xsl:comment><xsl:value-of select='name()'/>: <xsl:value-of select='@name'/></xsl:comment>
		<dotml:edge from="{@from}" to="{@to}" color="{$message-color}" fontname="{$fontname}" fontcolor="{$message-color}" fontsize="{$font-size-h2}" />
	</xsl:template>

	
	<!-- Render the links from published messages to services -->
	<xsl:template match='Service' mode='link'>
		<xsl:comment> Links for <xsl:value-of select='@name'/>  </xsl:comment>
		<xsl:variable name="service" select='.'/>
		
		<xsl:choose>
			<xsl:when test="$message-format = 'node'">
				<xsl:for-each select="ServiceConnections/ServiceConnection[@type='publish']/Message">
					<xsl:variable name='message-id' select="concat($service/@id, '_', @id-ref)"/>
					<xsl:variable name='to' select='../@id-ref'/>
					<dotml:edge from="{$message-id}" to="{$to}" color='{$message-color}' />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ServiceConnections/ServiceConnection[@type='publish']">
					<xsl:variable name='label'>
						<xsl:if test="$message-format = 'label'">
							<xsl:call-template name='concat-names'>
								<xsl:with-param name='nodes' select='Message'/>
							</xsl:call-template>
						</xsl:if>
					</xsl:variable>
					<dotml:edge from="{$service/@id}" to="{@id-ref}" label='{$label}' 
					  color="{$message-color}" fontname="{$fontname}" fontcolor="{$message-color}" fontsize="{$font-size-h2}" />
				</xsl:for-each>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="concat-names">
		<xsl:param name="nodes" select='*'/>
		<xsl:for-each select='$nodes[@name]'>
			<xsl:if test='position() > 1'>\n</xsl:if>
			<xsl:value-of select='@name'/>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>

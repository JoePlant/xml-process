<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

	<xsl:output method="xml" indent="yes" />

	<xsl:key name='inputs-by-name' match='Input' use='@name' />
	<xsl:key name='consumables-by-name' match='Consumable' use='@name' />
	<xsl:key name='waste-by-name' match='Waste' use='@name' />
	<xsl:key name='outputs-by-name' match='Output' use='@name' />
	<xsl:key name='flows-by-to' match='Flow' use='@to' />
	<xsl:key name='areas-by-name' match='Area' use='@name' />
	<xsl:key name='link-by-to' match='Link' use='@to' />

	<xsl:key name='node-by-name' match='Area' use='@name' />
		
	<xsl:variable name='list-inputs' select="//Input[count(. | key('inputs-by-name', @name)[1]) = 1]" />
	<xsl:variable name='list-consumables' select="//Consumable[count(. | key('consumables-by-name', @name)[1]) = 1]" />
	<xsl:variable name='list-waste' select="//Waste[count(. | key('waste-by-name', @name)[1]) = 1]" />
	<xsl:variable name='list-outputs' select="//Output[count(. | key('outputs-by-name', @name)[1]) = 1]" />
	<xsl:variable name='list-areas' select="//Area[count(. | key('areas-by-name', @name)[1]) = 1]" />	
	
	<xsl:template match='/'>
		<ProcessFlow >
			<xsl:apply-templates select="ProcessFlow/@*"/>
			<InputsView>
				<xsl:apply-templates select='$list-inputs' >
					<xsl:sort select='@name'/>
				</xsl:apply-templates>
			</InputsView>
			<OutputsView>
				<xsl:apply-templates select='$list-outputs' >
					<xsl:sort select='@name'/>
				</xsl:apply-templates>
			</OutputsView>
			<ConsumablesView>
				<xsl:apply-templates select='$list-consumables' >
					<xsl:sort select='@name'/>
				</xsl:apply-templates>
			</ConsumablesView>
			<WasteView>
				<xsl:apply-templates select='$list-waste' >
					<xsl:sort select='@name'/>
				</xsl:apply-templates>
			</WasteView>
			<AreasView>
				<xsl:apply-templates select='/ProcessFlow/Area' >
					<xsl:sort select='@name'/>
				</xsl:apply-templates>
			</AreasView>
			<FlowsView>
				<xsl:apply-templates select='//Flow' >
					<xsl:sort select='../@name'/>
					<xsl:sort select='@to'/>
				</xsl:apply-templates>
			</FlowsView>
			<LinksView>
				<xsl:apply-templates select='//Link' >
					<xsl:sort select='../@name'/>
					<xsl:sort select='@to'/>
				</xsl:apply-templates>
			</LinksView>
		</ProcessFlow>				
	</xsl:template>

	<xsl:template match='Input'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<Input id='{$id}' index='{position()}' name="{@name}">
			<xsl:for-each select="key('inputs-by-name', @name)">
				<xsl:variable name='parent-id' select='generate-id(..)'/>
				<Flow from ='{$id}' to='{$parent-id}' />
			</xsl:for-each>
		</Input>
	</xsl:template>

	<xsl:template match='Consumable'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<Consumable id='{$id}' index='{position()}' name="{@name}">
			<xsl:for-each select="key('consumables-by-name', @name)">
				<xsl:variable name='parent-id' select='generate-id(..)'/>
				<Flow from ='{$id}' to='{$parent-id}' />
			</xsl:for-each>
		</Consumable>
	</xsl:template>

	<xsl:template match='Output'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<Output id='{$id}' index='{position()}' name="{@name}">
			<xsl:for-each select="key('outputs-by-name', @name)">
				<xsl:variable name='parent-id' select='generate-id(..)'/>
				<Flow from='{$parent-id}' to='{$id}'  />
			</xsl:for-each>
		</Output>
	</xsl:template>

	<xsl:template match='Waste'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<Waste id='{$id}' index='{position()}' name="{@name}">
			<xsl:for-each select="key('waste-by-name', @name)">
				<xsl:variable name='parent-id' select='generate-id(..)'/>
				<Flow from='{$parent-id}' to='{$id}'  />
			</xsl:for-each>
		</Waste>
	</xsl:template>
	
	<xsl:template match='Area'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<xsl:choose>
			<xsl:when test='Area'>
				<Area id='{$id}' index='{position()}' name="{@name}" >
					<xsl:apply-templates select='Area'/>
				</Area>
			</xsl:when>
			<xsl:otherwise>
				<WorkCentre id='{$id}' index='{position()}' name="{@name}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match='Flow[@to]'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<xsl:variable name='parent-id' select='generate-id(..)'/>
		<xsl:variable name='to-node' select="key('node-by-name', @to)[1]"/>
		<xsl:choose>
			<xsl:when test='$to-node'>
				<Flow id='{$id}' index='{position()}' name="{concat(../@name, ' to ', @to)}" from="{$parent-id}" to="{generate-id($to-node)}" />
			</xsl:when>
			<xsl:otherwise>
				<!-- @to does not reference an area -->
				<Flow id='{$id}' index='{position()}' name="{concat(../@name, ' to ', @to)}" from="{$parent-id}" to="{@to}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match='Flow[@from]'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<xsl:variable name='parent-id' select='generate-id(..)'/>
		<xsl:variable name='from-node' select="key('node-by-name', @from)[1]"/>
		<Flow id='{$id}' index='{position()}' name="{concat(@from, ' to ', ../@name)}" from="{generate-id($from-node)}" to="{$parent-id}" />
	</xsl:template>

	<xsl:template match='Link[@to]'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<xsl:variable name='parent-id' select='generate-id(..)'/>
		<xsl:variable name='to-node' select="key('node-by-name', @to)[1]"/>
		<xsl:choose>
			<xsl:when test='$to-node'>
				<Link id='{$id}' index='{position()}' name="{concat(../@name, ' to ', @to)}" from="{$parent-id}" to="{generate-id($to-node)}" />
			</xsl:when>
			<xsl:otherwise>
				<!-- @to does not reference an area -->
				<Link id='{$id}' index='{position()}' name="{concat(../@name, ' to ', @to)}" from="{$parent-id}" to="{@to}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match='Link[@from]'>
		<xsl:variable name='id' select='generate-id(.)'/>
		<xsl:variable name='parent-id' select='generate-id(..)'/>
		<xsl:variable name='from-node' select="key('node-by-name', @from)[1]"/>
		<Link id='{$id}' index='{position()}' name="{concat(@from, ' to ', ../@name)}" from="{generate-id($from-node)}" to="{$parent-id}" />
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>

</xsl:stylesheet>


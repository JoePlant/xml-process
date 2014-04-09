xml-process
===========

A simple xml structure for representing process flows and is used to generate process flow diagrams.

Process Flow (top-bottom)          | Process flow (left-right)
-----------------------------------|-----------------------------------
![Top Flow](./doc/Examples/MultiSite/process-top-flow.png) | ![Left Flow](./doc/Examples/MultiSite/process-left-flow.png)

XmlSource: ![Process Flow] (./doc/Examples/MultiSite/ProcessFlow.xml) 
```xml
<ProcessFlow>
	<Area name='Concentrator'>
		<Input name='Ore'/>
		<Consumable name='Water'/>
		<Consumable name='Energy'/>
		<Waste name='Waste'/>
		<Flow to='Smelter'/>
	</Area>
	<Area name='Smelter'>
		<Consumable name='Water'/>
		<Consumable name='Energy'/>
		<Waste name='Slag'/>
		<Output name='Product'/>
	</Area>
</ProcessFlow>
```
===
### Elements

#### Input
Input flow for the process.
 - name = name of the flow
 
Xml: [Source](./doc/Examples/Input/ProcessFlow.xml)
``` xml
<ProcessFlow name='Example: Input'>
	<Area name='Site'>
		<Input name='Ore'/>
	</Area>
</ProcessFlow>
```

![Input](./doc/Examples/Input/process-top-flow.png)
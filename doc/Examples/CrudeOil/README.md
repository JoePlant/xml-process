Crude Oil Example
===========

An example showing the process flow output given the following 

Source Diagram            | Process flow (left-right)
--------------------------|-----------------------------------
![Source](./Refining.png) | ![Process Flow Output](./process-top-flow.png)

Xml: [Source](./ProcessFlow.xml) 
```xml
<ProcessFlow name='Crude Oil Refining'>
	<Area name='Atmospheric Distillation'>
		<Input name='Crude Oil'/>
		<Flow to='Vacuum Distillation'/>
		<Flow to='Kerosene Hydrocracker'/>
		<Flow to='Naphtha Hydrotreater'/>
	</Area>
	<Area name='Vacuum Distillation'>
		<Flow to='Coker'/>
		<Flow to='Fluid Catalytic Cracker'/>
	</Area>
	<Area name='Coker'>
		<Flow to='Hydrocracker'/>
		<Flow to='Diesel Hydrotreater'/>
	</Area>
	<Area name='Fluid Catalytic Cracker'>
		<Flow to='Diesel Hydrotreater'/>
		<Flow to='Gasoline Hydrotreater'/>
	</Area>
	<Area name='Hydrocracker'>
		<Output name='Heavy Oils' />
	</Area>
	<Area name='Diesel Hydrotreater'>
		<Output name='Diesel' />
	</Area>
	<Area name='Gasoline Hydrotreater'>
		<Output name='Gasoline' />
	</Area>
	<Area name='Kerosene Hydrocracker'>
		<Output name='Kerosene' />
	</Area>
	<Area name='Naphtha Hydrotreater'>
		<Flow to='Naphtha Reformer'/>
		<Flow to='Isomerization Unit'/>
	</Area>
	<Area name='Naphtha Reformer'>
		<Output name='Naphtha' />
	</Area>
	<Area name='Isomerization Unit'>
		<Output name='Kerosene' />
	</Area>
</ProcessFlow>
```

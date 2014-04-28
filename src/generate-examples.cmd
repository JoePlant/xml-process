@echo off

call generate-core ..\doc\Examples\Simple\ProcessFlow.xml ..\doc\Examples\Simple\
call generate-core ..\doc\Examples\MultiSite\ProcessFlow.xml ..\doc\Examples\MultiSite\

call generate-core ..\doc\Examples\Area\ProcessFlow.xml ..\doc\Examples\Area\

call generate-core ..\doc\Examples\Input\ProcessFlow.xml ..\doc\Examples\Input\
call generate-core ..\doc\Examples\Output\ProcessFlow.xml ..\doc\Examples\Output\
call generate-core ..\doc\Examples\Consumable\ProcessFlow.xml ..\doc\Examples\Consumable\
call generate-core ..\doc\Examples\Waste\ProcessFlow.xml ..\doc\Examples\Waste\
call generate-core ..\doc\Examples\Flow\ProcessFlow.xml ..\doc\Examples\Flow\
call generate-core ..\doc\Examples\Link\ProcessFlow.xml ..\doc\Examples\Link\

call generate-core ..\doc\Examples\Gold\ProcessFlow.xml ..\doc\Examples\Gold\
call generate-core ..\doc\Examples\Magnetite\ProcessFlow.xml ..\doc\Examples\Magnetite\
call generate-core ..\doc\Examples\CrudeOil\ProcessFlow.xml ..\doc\Examples\CrudeOil\

pause
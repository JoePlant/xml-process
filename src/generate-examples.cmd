echo off
call generate-core ..\doc\Examples\Simple\ProcessFlow.xml ..\doc\Examples\Simple
call generate-core ..\doc\Examples\MultiSite\ProcessFlow.xml ..\doc\Examples\MultiSite

call generate-core ..\doc\Examples\Input\ProcessFlow.xml ..\doc\Examples\Input
call generate-core ..\doc\Examples\Output\ProcessFlow.xml ..\doc\Examples\Output
call generate-core ..\doc\Examples\Consumable\ProcessFlow.xml ..\doc\Examples\Consumable
call generate-core ..\doc\Examples\Waste\ProcessFlow.xml ..\doc\Examples\Waste

pause
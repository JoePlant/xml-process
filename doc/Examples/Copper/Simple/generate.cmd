@echo off
set current=%~dp0

pushd ..\..\..\..\src
call generate-core %current%ProcessFlow.xml %current%
popd

pause
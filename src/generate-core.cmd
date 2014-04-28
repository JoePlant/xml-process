
set model=%1
set output=%2

if EXIST %output% goto output_exists
mkdir %output%
:output_exists

if NOT EXIST %model% goto ERROR
if NOT EXIST %output% goto ERROR

if EXIST Working goto Working_exists
mkdir %current%Working
:Working_exists

set nxslt=..\lib\nxslt\nxslt.exe
set graphviz=..\lib\GraphViz-2.30.1\bin
set dotml=..\lib\dotml-1.4
set xsltproc=..\lib\libxml\bin\xsltproc.exe 

@echo === Model ======
@echo Model = %model%
%nxslt% %model% StyleSheets\generate-model.xslt -o Working\model.xml 

@echo   Generated: Working\model.xml

@echo === Diagrams ===

%nxslt% Working\model.xml StyleSheets\render-process.xslt -o Working\process-flow-tb.dotml direction=TB
%nxslt% Working\model.xml StyleSheets\render-process.xslt -o Working\process-flow-lr.dotml direction=LR
%nxslt% Working\process-flow-tb.dotml %dotml%\dotml2dot.xsl -o "Working\process-flow-tb.gv" 
%nxslt% Working\process-flow-lr.dotml %dotml%\dotml2dot.xsl -o "Working\process-flow-lr.gv" 
%graphviz%\dot.exe -Tpng "Working\process-flow-tb.gv"  -o "%output%\process-top-flow.png"
%graphviz%\dot.exe -Tpng "Working\process-flow-lr.gv"  -o "%output%\process-left-flow.png"

@echo   Generated: %output%process-top-flow.png
@echo   Generated: %output%process-left-flow.png

@echo ================

goto end

:Error
echo Something is not right. 
echo Please check that these exist
echo Model=%model%
echo OutputDir=%output%

:end
rem pause
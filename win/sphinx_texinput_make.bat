@@echo off
setlocal

::set %LATEXOPTS%=

if "%1" EQU "all-pdf" goto all-pdf
if "%1" EQU "all-dvi" goto all-dvi
if "%1" EQU "all-ps" goto all-ps
if "%1" EQU "all-pdf-ja" goto all-pdf-ja
if "%1" EQU "clean" goto clean

:all-pdf
for %%f in (*.tex) do pdflatex %LATEXOPTS% %%f
for %%f in (*.tex) do pdflatex %LATEXOPTS% %%f
for %%f in (*.tex) do pdflatex %LATEXOPTS% %%f
for %%f in (*.idx) do if exist %%f (makeindex -s python.ist %%f)
for %%f in (*.tex) do pdflatex %LATEXOPTS% %%f
for %%f in (*.tex) do pdflatex %LATEXOPTS% %%f
goto end

:all-dvi
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.idx) do if exist %%f (makeindex -s python.ist %%f)
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.tex) do latex %LATEXOPTS% %%f
goto end

:all-ps
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.idx) do if exist %%f (makeindex -s python.ist %%f)
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.tex) do latex %LATEXOPTS% %%f
for %%f in (*.dvi) do dvips %%f
goto end

:all-pdf-ja
for %%f in (*.pdf *.png *.gif *.jpg *.jpeg) do extractbb %%f
for %%f in (*.tex) do platex -kanji=utf8 %LATEXOPTS% %%f
for %%f in (*.tex) do platex -kanji=utf8 %LATEXOPTS% %%f
for %%f in (*.tex) do platex -kanji=utf8 %LATEXOPTS% %%f
for %%f in (*.idx) do if exist %%f (mendex -U -f -d "`basename %%f .idx`.dic" -s python.ist %%f)
for %%f in (*.tex) do platex -kanji=utf8 %LATEXOPTS% %%f
for %%f in (*.tex) do platex -kanji=utf8 %LATEXOPTS% %%f
for %%f in (*.dvi) do dvipdfmx %%f
goto end

:clean
del *.dvi *.log *.ind *.aux *.toc *.syn *.idx *.out *.ilg *.pla
goto end

:end


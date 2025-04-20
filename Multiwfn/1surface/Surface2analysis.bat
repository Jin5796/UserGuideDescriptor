for /f %%i in ('dir *.fchk /b') do (
Multiwfn %%i < Surface_Analysis.txt > %%~ni_Surface.txt
)

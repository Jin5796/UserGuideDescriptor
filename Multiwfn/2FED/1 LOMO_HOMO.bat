for /f %%i in ('dir *.fchk /b') do (
Multiwfn %%i < LOMO_HOMO.txt > %%~ni_LOMO_HOMO.txt
)
pause
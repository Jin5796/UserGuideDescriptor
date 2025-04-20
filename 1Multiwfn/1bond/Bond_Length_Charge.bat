for /f %%i in ('dir *.fchk /b') do (
Multiwfn %%i < Bond_Length_Charge.txt > %%~ni_Bond_Length_Chargenouse.txt
)
pause
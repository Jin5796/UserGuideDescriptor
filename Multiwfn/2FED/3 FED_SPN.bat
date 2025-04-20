echo fchk of SP N
for /f %%i in ('dir *.fchk /b') do (
Multiwfn %%i < %%~ni_FED_SPN.txt > %%~ni_FED.txt
)

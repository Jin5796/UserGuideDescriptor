# fchk of SP N
for /f %%i in ('dir *.fchk /b') do (
Multiwfn %%i < Superdelocalizability_SPN.txt > %%~ni_Superdelocalizability_2nd.txt
)

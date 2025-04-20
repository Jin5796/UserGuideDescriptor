# fchk of SP N
for /f %%i in ('dir *.fchk /b') do (
Multiwfn %%i < Weighted_Condensed_FuiKui_SPN.txt > %%~ni_Weighted_Condensed_FuiKui.txt
)

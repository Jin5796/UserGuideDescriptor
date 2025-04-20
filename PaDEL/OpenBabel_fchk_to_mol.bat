md D:\\111\\SCUT_HPC\\fchk\\
for /f %%i in ('dir *.fchk /b') do (
obabel %%i -O %%~ni.mol
move %%~ni.mol D:\\111\\SCUT_HPC\\fchk\\fchk_mol\\
)
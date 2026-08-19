@echo off
cd /d D4

for %%d in (..\Examples\, ..\Tests\) do (
    for %%i in ("%%d*.pas") do (
        dcc32 -Q -U..\Modules "%%i"
    )
)

pause

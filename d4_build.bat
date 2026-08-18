@echo off
cd /d D4

for %%i in (..\*.pas) do (
    dcc32 -Q -U..\Modules "%%i"
)

pause

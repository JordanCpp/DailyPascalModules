
@echo off

for %%i in (*.pas) do (
    C:\FPC\3.2.2\bin\i386-win32\fpc -FUBuild -FuModules "%%i"
)

pause

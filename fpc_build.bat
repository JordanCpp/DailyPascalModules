@echo off

for %%d in (Examples Tests) do (
    for %%i in (%%d\*.pas) do (
        C:\FPC\3.2.2\bin\i386-win32\fpc -FUBuild -FuModules "%%i"
    )
)

pause

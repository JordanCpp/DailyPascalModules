
@echo off

for %%d in (Examples Tests) do (
    for %%i in (%%d\*.pas) do (
        C:\FPC\3.2.2\bin\i386-win32\fpc -B -O3 -CpCOREAVX2 -CfAVX2 -Twin64 -Px86_64 -FUBuild -FuModules "%%i"
    )
)

pause


@echo off

for %%d in (Examples Tests) do (
    for %%i in (%%d\*.pas) do (
        %1 -O3 -v0 -Twin64 -Px86_64 -FUBuild -FuModules "%%i"
    )
)

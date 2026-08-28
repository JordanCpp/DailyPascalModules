@echo off

for %%d in (Examples\OpenGL Examples\Painter Tests) do (
    for %%i in (%%d\*.pas) do (
        %1 -O3 -v0 -FUBuild -FuModules "%%i"
    )
)

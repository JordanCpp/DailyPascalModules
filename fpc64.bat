
@echo off

for %%d in (Examples\OpenGL1 Examples\OpenGL3 Examples\Painter Tests) do (
    for %%i in (%%d\*.pas) do (
        %1 -O3 -v0 -Twin64 -Px86_64 -FUBuild -FuModules "%%i"
    )
)

#!/bin/bash

mkdir -p Build

for d in "Examples/OpenGL" "Examples/Painter" "Tests"; do
    for i in "$d"/*.pas; do
        if [ -f "$i" ]; then
            fpc -O3 -FUBuild -FuModules "$i"
        fi
    done
done

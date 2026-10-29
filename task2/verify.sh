#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Ubuntu supplies GoogleTest in the standard compiler and linker paths.
cxxflags="-std=c++17"
ldflags="-lgtest -lgtest_main -pthread"
if [[ "$(uname -s)" == "Darwin" ]]; then
    gtest_prefix="$(brew --prefix googletest)"
    cxxflags+=" -isystem ${gtest_prefix}/include"
    ldflags+=" -L${gtest_prefix}/lib"
fi

verilator -Wall --trace --cc f1_fsm.sv --exe verify.cpp \
    --prefix Vdut -o Vdut \
    -CFLAGS "$cxxflags" -LDFLAGS "$ldflags"
make -j -C obj_dir/ -f Vdut.mk
./obj_dir/Vdut

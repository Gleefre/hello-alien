#!/bin/sh
set -e

# Guessing architecture.
uname_arch=`adb shell uname -m`
case $uname_arch in
    x86_64) abi=x86_64 ;;
    aarch64) abi=arm64-v8a ;;
    *) echo "Architecture $uname_arch is not supported."
       exit 1 ;;
esac
echo "Architecture $abi determined."

CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/$uname_arch-linux-android21-clang

# Library
$CC -fPIC -shared -o libs/$abi/libhello-alien.so c/hello-alien.c -lm -llog -lsbcl -Llibs/$abi

# Compile as shell app
$CC -fPIC -rdynamic -o artifacts/$abi/hello-alien -DSHELL c/hello-alien.c -lm -llog -lsbcl -Llibs/$abi

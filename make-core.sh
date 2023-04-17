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

# Remove previous core
adb shell rm -f /data/local/tmp/alien.lisp
adb shell rm -f /data/local/tmp/alien.core

echo "Building core"
adb push lisp/alien.lisp /data/local/tmp
adb shell "cd /data/local/tmp ; ./sbcl/run-sbcl.sh --load alien.lisp";
adb pull /data/local/tmp/libcore.so

# Move core to artifacts
echo "Moving core to libs/$abi"
mv alien.core libs/$abi/libcore.so

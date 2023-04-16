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
adb pull /data/local/tmp/alien.core

# Move core to artifacts
echo "Moving core to artifacts/$abi/alien.core"
mv alien.core artifacts/$abi/alien.core

# Copy as fake libcore.so
echo "Copying to libs/$abi"
cp artifacts/$abi/alien.core libs/$abi/libcore.so

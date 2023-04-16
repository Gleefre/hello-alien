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

adb push libs/$abi/libsbcl.so /data/local/tmp
adb push artifacts/$abi/hello-alien /data/local/tmp
adb push artifacts/$abi/alien.core /data/local/tmp
adb shell "cd /data/local/tmp ; LD_LIBRARY_PATH=/data/local/tmp ./hello-alien"

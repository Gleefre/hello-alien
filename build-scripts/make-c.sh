#!/bin/sh
set -e

# Check for NDK
if [ -z $NDK ] || [ ! -d $NDK ]; then
    echo "Can't find Android NDK, please set the $NDK environment variable."
    exit 1
fi

# Determine target ABI
if [ -n "$1" ]; then
    ABI=$1
elif [ -z "$ABI" ]; then
    uname_arch=`adb shell uname -m`

    case $uname_arch in
        x86_64) ABI=x86_64 ;;
        aarch64) ABI=arm64-v8a ;;
        *) echo "Architecture $uname_arch is not supported."
           exit 1 ;;
    esac
fi
echo "Determined target $ABI."

case $ABI in
    x86_64) TARGET_TAG=x86_64-linux-android ;;
    arm64-v8a) TARGET_TAG=aarch64-linux-android ;;
    *) echo "ABI $ABI is not supported."
       exit 1 ;;
esac

ANDROID_API=21
HOST_TAG=linux-x86_64

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
CC=$TOOLCHAIN/bin/$TARGET_TAG$ANDROID_API-clang

echo $CC -fPIC -shared -o prebuilt/libs/$ABI/lib.gleefre.wrap.so src/c/wrap.c -lsbcl -llog -Lprebuilt/libs/$ABI
$CC -fPIC -shared -o prebuilt/libs/$ABI/lib.gleefre.wrap.so src/c/wrap.c -lsbcl -llog -Lprebuilt/libs/$ABI

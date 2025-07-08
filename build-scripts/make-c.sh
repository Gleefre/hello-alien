#!/bin/sh
set -e

. build-scripts/config.sh

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
        *86 | i86pc) ABI=x86 ;;
        *x86_64 | amd64) ABI=x86_64 ;;
        aarch64 | arm64) ABI=arm64-v8a ;;
        *arm*) ABI=armeabi-v7a ;;
        *) echo "Architecture $uname_arch is not supported."
           exit 1 ;;
    esac
fi
echo "Determined target $ABI."

case $ABI in
    x86) TARGET_TAG=i686-linux-android ;;
    x86_64) TARGET_TAG=x86_64-linux-android ;;
    arm64-v8a) TARGET_TAG=aarch64-linux-android ;;
    armeabi-v7a) TARGET_TAG=armv7a-linux-androideabi ;;
    *) echo "ABI $ABI is not supported."
       exit 1 ;;
esac

ANDROID_API=21
HOST_TAG=linux-x86_64

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
CC=$TOOLCHAIN/bin/$TARGET_TAG$ANDROID_API-clang

echo $CC -fPIC -shared -o prebuilt/libs/$ABI/"$APP_LIB_WRAPPER_NAME" src/c/wrap.c -lsbcl -llog -Lprebuilt/libs/$ABI
$CC -fPIC -shared -o prebuilt/libs/$ABI/"$APP_LIB_WRAPPER_NAME" src/c/wrap.c -lsbcl -llog -Lprebuilt/libs/$ABI

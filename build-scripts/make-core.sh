#!/bin/sh
set -e

. build-scripts/config.sh

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

jni_libs=prebuilt/libs/$ABI

# Clean core and lisp source (adb)
adb shell rm -rf "$APP_HOME_DIR"/lisp
adb shell rm -f "$APP_HOME_DIR"/"$APP_LISP_CORE_NAME"

# Push lisp source
( cd src/lisp;
  adb push ./ "$APP_HOME_DIR"/lisp )

# Build core
echo "Building core"
adb shell "cd \"$APP_HOME_DIR\"; HOME=\"\$(pwd)\" sh sbcl/run-sbcl.sh --load \"lisp/$APP_LISP_ENTRY\"";

# Copy core into prebuilt/libs
echo "Copying $APP_LISP_CORE_NAME to $jni_libs"
adb pull "$APP_HOME_DIR"/"$APP_LISP_CORE_NAME" "$jni_libs"

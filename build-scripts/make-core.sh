#!/bin/sh
set -e

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

lisp_dir=hello-alien
lisp_entry=alien.lisp
lisp_core=lib.gleefre.core.so
jni_libs=prebuilt/libs/$ABI

# Clean core and lisp source (adb)
adb shell rm -rf /data/local/tmp/"$lisp_dir"
adb shell rm -f /data/local/tmp/"$lisp_core"

# Push lisp source
adb push src/lisp/ /data/local/tmp/"$lisp_dir"/

# Build core
echo "Building core"
adb shell "cd /data/local/tmp ; export HOME=\$(pwd) ; ./sbcl/run-sbcl.sh --load $lisp_dir/$lisp_entry";

# Copy core into prebuilt/libs
echo "Copying $lisp_core to $jni_libs"
adb pull /data/local/tmp/"$lisp_core" "$jni_libs"

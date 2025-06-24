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

# Cloning sbcl if needed (from my fork)
if [ -d sbcl-$abi ];
then
    echo "sbcl-$abi already exists."
else
    git clone https://github.com/Gleefre/sbcl.git -b pass-pointer-to-lisp sbcl-$abi
fi

# Setup libzstd for core compression
mkdir -p sbcl-$abi/android-libs
cp zstd-headers/* sbcl-$abi/android-libs/
cp libs/$abi/libzstd.so sbcl-$abi/android-libs/

# Building sbcl
echo "Building sbcl."
cd sbcl-$abi
echo '"ANDROID-WIP"' > version.lisp-expr
./make-android.sh --fancy
cd ..

# Copy library to libs folder
echo "Copying sbcl-$abi/src/runtime/libsbcl.so to libs/$abi/libsbcl.so."
cp sbcl-$abi/src/runtime/libsbcl.so libs/$abi/libsbcl.so

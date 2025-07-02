#!/bin/sh
set -e

if [ -n "$1" ]; then
    DIR=$1
elif [ -z "$DIR" ]; then
    DIR=sbcl-pack
fi

mkdir -p "$DIR/obj"
mkdir -p "$DIR/output"
mkdir -p "$DIR/src/runtime"
if [ -d output/android-libs ]; then
    cp -r output/android-libs "$DIR/output"
fi
cp src/runtime/sbcl src/runtime/libsbcl.so "$DIR/src/runtime"
cp output/sbcl.core "$DIR/output"
cp -r obj/sbcl-home "$DIR/obj"
cp run-sbcl.sh BUGS NEWS COPYING CREDITS pubring.pgp README "$DIR"

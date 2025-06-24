#!/bin/sh
set -e

if [ -n "$1" ]; then
    DIR=$1
elif [ -z "$DIR" ]; then
    DIR=sbcl-pack
fi

mkdir -p android-libs
mkdir -p "$DIR/obj"
mkdir -p "$DIR/output"
mkdir -p "$DIR/src/runtime"
cp -r android-libs "$DIR"
cp src/runtime/sbcl src/runtime/libsbcl.so "$DIR/src/runtime"
cp output/sbcl.core "$DIR/output"
cp -r obj/sbcl-home "$DIR/obj"
cp run-sbcl.sh BUGS NEWS COPYING CREDITS pubring.pgp README "$DIR"

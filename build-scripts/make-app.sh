#!/bin/sh
set -e

# Lisp, C and Java
./build-scripts/make-core.sh
./build-scripts/make-c.sh
./build-scripts/make-java.sh  # basically ./gradlew assembleDebug

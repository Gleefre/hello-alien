#!/bin/sh
set -e

# Like make-app, but without recompiling the core.
# Useful when modifying C/Java side only.
./build-scripts/make-c.sh
./build-scripts/make-java.sh  # basically ./gradlew assembleDebug

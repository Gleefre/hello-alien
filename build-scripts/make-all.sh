#!/bin/sh
set -e

./make-sbcl.sh
./make-core.sh
./make-c.sh

./gradlew assembleDebug

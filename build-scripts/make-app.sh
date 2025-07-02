#!/bin/sh
set -e

. build-scripts/config.sh

# Lisp, C and Java
./build-scripts/make-core.sh
./build-scripts/make-c.sh
./build-scripts/make-java.sh  # basically ./gradlew assembleDebug

mkdir -p prebuilt/apk  # in case it was deleted

echo ""
echo "Build finished successfuly!"
echo ""
echo "You can update the prebuilt apk like this:"
echo "  cp build/outputs/apk/debug/$APP_NAME-debug.apk prebuilt/apk/"
echo ""
echo "You can use gradlew to install the app on the connected android device:"
echo "  ./gradlew installDebug"

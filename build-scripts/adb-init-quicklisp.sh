#!/bin/sh

. build-scripts/config.sh

if [ "$APP_NO_QUICKLISP" = "true" ]; then
    exit 0
fi

if [ ! -f build/external/quicklisp.lisp ]; then
    mkdir -p build/external
    ( cd build/external;
      wget https://beta.quicklisp.org/quicklisp.lisp )
fi

# Clean (adb)
adb shell rm -rf "$APP_HOME_DIR"/quicklisp
adb shell rm -rf "$APP_HOME_DIR"/quicklisp.lisp
adb shell rm -rf "$APP_HOME_DIR"/.slime
adb shell rm -rf "$APP_HOME_DIR"/.sbclrc
adb shell rm -rf "$APP_HOME_DIR"/.cache/common-lisp

# Install quicklisp (adb)
adb push build/external/quicklisp.lisp "$APP_HOME_DIR"/quicklisp.lisp
adb shell "cd \"$APP_HOME_DIR\"; HOME=\"\$(pwd)\" sh sbcl/run-sbcl.sh --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(ql-util:without-prompting (ql:add-to-init-file))' --quit"
adb shell rm -rf "$APP_HOME_DIR"/quicklisp.lisp

#!/bin/sh
set -e

# Lisp environment (sbcl, quicklisp, local-projects)
./build-scripts/make-sbcl.sh
./build-scripts/adb-init-quicklisp.sh
./build-scripts/adb-init-local-projects.sh

#!/bin/sh
set -e

. build-scripts/config.sh

if [ "$APP_NO_LOCAL_PROJECTS" = "true" ]; then
    exit 0
fi

if [ ! -d build/external/local-projects ]; then
    mkdir -p build/external/local-projects
    ( cd build/external/local-projects;
      app_clone_local_projects )
fi

echo "deleting and re-pushing $APP_HOME_DIR/quicklisp/local-projects"
adb shell rm -rf "$APP_HOME_DIR"/quicklisp/local-projects

( cd build/external/local-projects;
  adb push ./ "$APP_HOME_DIR"/quicklisp/local-projects )

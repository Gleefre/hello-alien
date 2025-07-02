export APP_NAME=hello-alien-app
export APP_HOME_DIR="/data/local/tmp/$APP_NAME"  # on the target device

APP_NO_QUICKLISP=true  # disable quicklisp
APP_NO_LOCAL_PROJECTS=true  # disable local projects
# app_clone_local_projects() {
# }

export APP_LISP_ENTRY=alien.lisp  # relative to src/lisp
export APP_LISP_CORE_NAME=lib.gleefre.core.so  # must match lib*.so
export APP_LIB_WRAPPER_NAME=lib.gleefre.wrap.so

# APP_LIB_WRAPPER_NAME and APP_LISP_CORE_NAME must match those used in the source code

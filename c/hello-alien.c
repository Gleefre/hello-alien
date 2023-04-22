#include <string.h>

extern int initialize_lisp(int argc, char **argv);
__attribute__((visibility("default"))) char* (*hello)();

__attribute__((visibility("default"))) char* hello_wrap() {
  return (*hello)();
}

__attribute__((visibility("default"))) int init(char* core) {
  char *init_args[] = {"", "--core", core, "--noinform", "--disable-ldb"};
  if (initialize_lisp(5, init_args) != 0) return -1;
  return 0;
}

#include <jni.h>
#include <string.h>
#include <dlfcn.h>

extern int initialize_lisp(int argc, char **argv);
extern void pass_pointer_to_lisp(void* pointer);

__attribute__((visibility("default"))) char* (*hello)();

int init(char* core) {
  char *init_args[] = {"", "--core", core, "--noinform", "--disable-ldb"};
  void* self_handle = dlopen("libhello-alien.so", RTLD_NOLOAD | RTLD_GLOBAL);
  if (self_handle == NULL) return -2;
  pass_pointer_to_lisp(self_handle);
  if (initialize_lisp(5, init_args) != 0) return -1;
  return 0;
}

JNIEXPORT void JNICALL
Java_hi_to_alien_HelloActivity_initLisp(JNIEnv *env, jobject thiz, jstring path) {
  char* core_filename = strdup((*env)->GetStringUTFChars(env, path, NULL));
  init(core_filename);
}

JNIEXPORT jstring JNICALL
Java_hi_to_alien_HelloActivity_getAlien(JNIEnv *env, jobject thiz) {
  return (*env)->NewStringUTF(env, hello());
}

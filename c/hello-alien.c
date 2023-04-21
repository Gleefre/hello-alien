#include <jni.h>
#include <string.h>

extern int initialize_lisp(int argc, char **argv);
__attribute__((visibility("default"))) char* (*hello)();

int init(char* core) {
  char *init_args[] = {"", "--core", core, "--noinform", "--disable-ldb"};
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
  const char* hello_string = hello();
  jstring java_hello_string = (*env)->NewStringUTF(env, hello_string);
  free(hello_string);
  return java_hello_string;
}

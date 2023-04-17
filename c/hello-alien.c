// #define SHELL
// #define FAKE

#ifdef SHELL
#include <stdio.h>
#else
#include <jni.h>
#endif

#include <string.h>

extern int initialize_lisp(int argc, char **argv);
__attribute__((visibility("default"))) char* (*hello)();

int init(char* core) {
  char *init_args[] = {"", "--core", core, "--noinform", "--disable-ldb"};
  if (initialize_lisp(5, init_args) != 0) return -1;
  return 0;
}

#ifdef FAKE
char* fake_hello() {
  return "I'm an alien!.. (fake)";
}
#endif

#ifndef SHELL
JNIEXPORT void JNICALL
Java_hi_to_alien_HelloActivity_initLisp(JNIEnv *env, jobject thiz, jstring path) {
#ifndef FAKE
  char* core_filename = strdup((*env)->GetStringUTFChars(env, path, NULL));
  init(core_filename);
#endif
}

JNIEXPORT jstring JNICALL
Java_hi_to_alien_HelloActivity_getAlien(JNIEnv *env, jobject thiz) {
#ifndef FAKE
  return (*env)->NewStringUTF(env, hello());
#else
  return (*env)->NewStringUTF(env, fake_hello());
#endif
}

#else // SHELL
int main(int argc, char **argv) {
  init("alien.core");
  printf("Alien: %s\n", hello());
  return 0;
}
#endif

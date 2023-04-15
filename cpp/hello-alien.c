// #define SHELL
// #define FAKE

#ifdef SHELL
#include <stdio.h>
#else
#include <jni.h>
#endif

#include <string.h>

extern int initialize_lisp(int argc, char **argv);
char* (*hello)();

char* core_filename = "alien.core";

int init(char* core) {
  char *init_args[] = {"", "--core", core, "--noinform", "--disable-ldb"};
  if (initialize_lisp(5, init_args) != 0) return -1;
  return 0;
}

char* fake_hello() {
  return core_filename;
}

#ifndef SHELL
JNIEXPORT void JNICALL
Java_hi_to_alien_HelloAlien_setCorePath(JNIEnv *env, jobject thiz, jstring name) {
  core_filename = strdup((*env)->GetStringUTFChars(env, name, NULL));
}

JNIEXPORT jstring JNICALL
Java_hi_to_alien_HelloAlien_getAlien(JNIEnv *env, jobject thiz) {
  #ifndef FAKE
  init(core_filename);
  return (*env)->NewStringUTF(env, hello());
  #else
  return (*env)->NewStringUTF(env, fake_hello());
  #endif
}
#else
int main(int argc, char **argv) {
  init("alien.core");
  printf("Alien: %s\n", hello());
  return 0;
}
#endif

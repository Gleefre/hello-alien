#include <jni.h>
#include <string.h>
#include <dlfcn.h>

#include <android/log.h>
#define TAG "ALIEN"
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR,    TAG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN,     TAG, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,     TAG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG,    TAG, __VA_ARGS__)

void* hello_alien_handle;
int (*init_here)(char*);
char* (*hello_here)();

JNIEXPORT void JNICALL
Java_hi_to_alien_HelloActivity_initLisp(JNIEnv *env, jobject thiz, jstring path) {
  LOGI("Here");
  char* core_filename = strdup((*env)->GetStringUTFChars(env, path, NULL));
  LOGI("Got name");
  hello_alien_handle = dlopen("libhello-alien.so", RTLD_GLOBAL | RTLD_NOW);
  LOGI("Got handle");
  LOGI("symbols before: %llu %llu", (unsigned long long) init_here, (unsigned long long) hello_here);
  init_here = dlsym(hello_alien_handle, "init");
  hello_here = dlsym(hello_alien_handle, "hello_wrap");
  LOGI("symbols  after: %llu %llu", (unsigned long long) init_here, (unsigned long long) hello_here);
  init_here(core_filename);
}

JNIEXPORT jstring JNICALL
Java_hi_to_alien_HelloActivity_getAlien(JNIEnv *env, jobject thiz) {
  LOGI("symbols in get: %llu %llu", (unsigned long long) init_here, (unsigned long long) hello_here);
  return (*env)->NewStringUTF(env, hello_here());
}

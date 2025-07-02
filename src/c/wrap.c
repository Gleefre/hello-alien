#include <jni.h>
#include <string.h>
#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <android/log.h>

#define LOG_TAG   "ALIEN/GLEEFRE/C"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN, LOG_TAG, __VA_ARGS__)

extern int initialize_lisp(int argc, char **argv, char **envp);
extern void pass_pointer_to_lisp(void* pointer);

__attribute__((visibility("default"))) char* (*hello)();

static int redirect_pipe[2];

void* redirect_worker(void* arg) {
    char buf[1024];
    ssize_t len;
    LOGI("Worker thread: entering the redirect loop");
    while ((len = read(redirect_pipe[0], buf, sizeof buf - 1)) > 0) {
        if (buf[len - 1] == '\n') --len;  // ignore trailing return if exists
        buf[len] = 0;  // add null-terminator
        __android_log_write(ANDROID_LOG_DEBUG, "ALIEN/GLEEFRE/C/REDIRECT", buf);
    }
    LOGI("Worker thread: exiting the redirect loop");
    return 0;
}

int redirect_stdout_stderr() {
  LOGI("Redirecting stdout/stderr to logcat");

  setvbuf(stdout, NULL, _IOLBF, 0);
  setvbuf(stderr, NULL, _IONBF, 0);
  LOGI("Changed buffering settings on stdout/stderr");

  pipe(redirect_pipe);
  LOGI("Created a pipe");

  dup2(redirect_pipe[1], 1);
  dup2(redirect_pipe[1], 2);
  LOGI("Redirected 1 & 2 to the input part of the pipe");

  pthread_t redirect_thread;
  if (pthread_create(&redirect_thread, NULL, redirect_worker, NULL) == -1) {
      LOGI("Failed to spawn a pipe->logcat thread");
      return -1;
  }
  LOGI("Spawned a pipe->logcat thread");

  pthread_detach(redirect_thread);
  LOGI("Detached the pipe->logcat thread");
  return 0;
}

int init(char* core) {
  LOGI("Lisp init");
  char *init_args[] = {"", "--core", core, "--disable-ldb", "--disable-debugger"};
  void* self_handle = dlopen("lib.gleefre.wrap.so", RTLD_NOLOAD | RTLD_GLOBAL);
  if (self_handle == NULL) return -2;
  pass_pointer_to_lisp(self_handle);
  if (initialize_lisp(5, init_args, NULL) != 0) return -1;
  return 0;
}

JNIEXPORT void JNICALL
Java_gleefre_hello_alien_HelloActivity_initLisp(JNIEnv *env, jobject thiz, jstring path) {
  LOGI("Redirecting stdout/stderr (status: %d)", redirect_stdout_stderr());
  char* core_filename = strdup((*env)->GetStringUTFChars(env, path, NULL));
  LOGI("Initializing lisp (status: %d)", init(core_filename));
}

JNIEXPORT jstring JNICALL
Java_gleefre_hello_alien_HelloActivity_getAlien(JNIEnv *env, jobject thiz) {
  LOGI("Calling into lisp from getAlien");
  return (*env)->NewStringUTF(env, hello());
}

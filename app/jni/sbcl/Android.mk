LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := sbcl
LOCAL_SRC_FILES := ${APP_ABI}/libsbcl.so

include $(PREBUILT_SHARED_LIBRARY)

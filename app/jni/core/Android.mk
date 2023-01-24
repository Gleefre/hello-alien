LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := core
LOCAL_SRC_FILES := libcore.so

include $(PREBUILT_SHARED_LIBRARY)

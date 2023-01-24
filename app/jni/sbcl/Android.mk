LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := sbcl
LOCAL_SRC_FILES := libsbcl.so

include $(PREBUILT_SHARED_LIBRARY)

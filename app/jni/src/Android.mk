LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := hello-alien
LOCAL_SRC_FILES := hello-alien.c

LOCAL_SHARED_LIBRARIES := sbcl

include $(BUILD_SHARED_LIBRARY)

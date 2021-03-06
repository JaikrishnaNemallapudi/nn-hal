LOCAL_PATH := $(call my-dir)

##############################################################
include $(CLEAR_VARS)

LOCAL_MODULE := android.hardware.neuralnetworks@1.2-generic-impl
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := intel
#LOCAL_MULTILIB := both
LOCAL_MULTILIB := 64

LOCAL_SRC_FILES := \
	Driver.cpp \
	PreparedModel.cpp

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/graphAPI

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/../../dldt/inference-engine/thirdparty/pugixml/src \
	$(LOCAL_PATH)/../../dldt/inference-engine/include \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/cpp \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/details \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/details/os \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/cldnn \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/gna \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/hetero \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/mkldnn \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/openvx \
	$(LOCAL_PATH)/../../dldt/inference-engine/include/vpu \
	$(LOCAL_PATH)/../../dldt/inference-engine/src/inference_engine \
	$(LOCAL_PATH)/../../dldt/inference-engine/src/dumper \
	$(LOCAL_PATH)/../../dldt/inference-engine/src/inference_engine/cpp_interfaces \
	$(LOCAL_PATH)/../../dldt/inference-engine/src/inference_engine/cpp_interfaces/base \
	$(LOCAL_PATH)/../../dldt/inference-engine/src/inference_engine/cpp_interfaces/impl \
	$(LOCAL_PATH)/../../dldt/inference-engine/src/inference_engine/cpp_interfaces/interface \
	frameworks/ml/nn/common/include \
	frameworks/ml/nn/runtime/include

LOCAL_CFLAGS += \
	-std=c++17 \
	-fPIC \
	-fPIE \
	-Wall \
	-Wno-unused-variable \
	-Wno-unused-parameter \
	-Wno-non-virtual-dtor \
	-Wno-missing-field-initializers \
	-Wno-error \
	-Wextra \
	-Wno-extern-c-compat \
	-Wno-sign-compare \
	-Wno-unused-local-typedef \
	-Wno-unused-private-field \
	-Wno-invalid-partial-specialization \
	-Wno-array-bounds \
	-D_FORTIFY_SOURCE=2 \
	-fvisibility=default \
	-fexceptions \
	-fwrapv \
    -fstack-protector-strong \
    -Wno-conversion-null \
    -Wnull-dereference \
    -Warray-bounds \
	-O0

LOCAL_CFLAGS += \
	-DIMPLEMENT_INFERENCE_ENGINE_API \
	-D__ANDROID__

LOCAL_CFLAGS +=  -DNN_DEBUG
#LOCAL_CFLAGS +=  -DAT_RUNTIME
#LOCAL_CFLAGS +=  -DNNLOG

LOCAL_SHARED_LIBRARIES := \
	libhidlbase \
	libhidltransport \
	libutils \
	liblog \
	libcutils \
	libhardware \
	libbase \
	libhidlmemory \
	android.hardware.neuralnetworks@1.0 \
	android.hardware.neuralnetworks@1.1 \
	android.hardware.neuralnetworks@1.2 \
	android.hidl.allocator@1.0 \
	android.hidl.memory@1.0 \
	libinference_engine

LOCAL_STATIC_LIBRARIES := libgraphAPI libpugixml libneuralnetworks_common

include $(BUILD_SHARED_LIBRARY)
###############################################################
include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.neuralnetworks@1.2-generic-service
LOCAL_INIT_RC := android.hardware.neuralnetworks@1.2-generic-cpu.rc \
    android.hardware.neuralnetworks@1.1-generic-gpu.rc
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := intel
LOCAL_SRC_FILES := \
	service.cpp

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH) \
	frameworks/ml/nn/common/include \
	frameworks/ml/nn/runtime/include

LOCAL_CFLAGS += -fexceptions -fPIE -std=c++17

LOCAL_SHARED_LIBRARIES := \
	libhidlbase \
	libhidltransport \
	libutils \
	liblog \
	libcutils \
	libhardware \
	android.hardware.neuralnetworks@1.2 \
	android.hardware.neuralnetworks@1.2-generic-impl

LOCAL_MULTILIB := 64

include $(BUILD_EXECUTABLE)
#############################################################

ZPATH := $(LOCAL_PATH)
include $(CLEAR_VARS)

include $(ZPATH)/graphAPI/graphAPI.mk
include $(ZPATH)/graphTests/graphTests.mk
include $(ZPATH)/dl/Android.mk
#include $(ZPATH)/ncsdk2/api/src/Android.mk

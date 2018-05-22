//
// INTEL CONFIDENTIAL
// Copyright 2017 Intel Corporation.
//
// The source code contained or described herein and all documents
// related to the source code ("Material") are owned by Intel Corporation
// or its suppliers or licensors. Title to the Material remains with
// Intel Corporation or its suppliers and licensors. The Material may
// contain trade secrets and proprietary and confidential information
// of Intel Corporation and its suppliers and licensors, and is protected
// by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified,
// published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other
// intellectual property right is granted to or conferred upon you by
// disclosure or delivery of the Materials, either expressly, by implication,
// inducement, estoppel or otherwise. Any license under such intellectual
// property rights must be express and approved by Intel in writing.
//
// Include any supplier copyright notices as supplier requires Intel to use.
//
// Include supplier trademarks or logos as supplier requires Intel to use,
// preceded by an asterisk. An asterisked footnote can be added as follows:
// *Third Party trademarks are the property of their respective owners.
//
// Unless otherwise agreed by Intel in writing, you may not remove or alter
// this notice or any other notice embedded in Materials by Intel or Intel's
// suppliers or licensors in any way.
//

/**
* @brief WINAPI based code
* @file win_omp_manager.h
*/

#pragma once

#include <thread>
#include <vector>
#include <windows.h>

namespace MKLDNNPlugin {
namespace cpu {

class OpenMpManager {
public:
    static int getOpenMpThreadNumber() {
        return getCoreNumber();
    }

    static int getCoreNumber() {
        int num_cores = std::thread::hardware_concurrency();
        unsigned long size = 0;

        if (!GetLogicalProcessorInformationEx(RelationProcessorCore, nullptr, &size)) {
            if (GetLastError() == ERROR_INSUFFICIENT_BUFFER) {
                std::vector<char> buf(size);
                SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX* info
                        = reinterpret_cast<SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX*>(&buf.front());
                SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX* ptr = info;
                if (GetLogicalProcessorInformationEx(RelationProcessorCore, info, &size)) {
                    if (GetLastError() == ERROR_SUCCESS) {
                        int num = 0;
                        unsigned long offset = 0;
                        while (offset < size) {
                            num++;
                            offset += ptr->Size;
                            ptr = reinterpret_cast<SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX*>(
                                    reinterpret_cast<byte*>(ptr) + ptr->Size);
                        }
                        num_cores = num;
                    }
                }
            }
        }
        return num_cores;
    }
};

}  // namespace cpu
}  // namespace MKLDNNPlugin

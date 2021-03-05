# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

#if("K64F" IN_LIST MBED_TARGET_LABELS)
#   add_subdirectory(TARGET_K64F)
#elseif("K66F" IN_LIST MBED_TARGET_LABELS)
#    add_subdirectory(TARGET_K66F)
#endif()

add_library(mbed-emac-k64f INTERFACE)
target_sources(mbed-emac-k64f
    INTERFACE
        TARGET_K64F/hardware_init_MK64F12.c
)

add_library(mbed-emac-k66f INTERFACE)
target_sources(mbed-emac-k66f
    INTERFACE
        TARGET_K66F/hardware_init_MK66F18.c
)

target_include_directories(mbed-emac
    INTERFACE
        .
)
target_sources(mbed-emac
    INTERFACE
        kinetis_emac.cpp
)
target_link_libraries(mbed-emac
    INTERFACE
        $<$<IN_LIST,K64F,INTERFACE_COMPILE_DEFINITIONS>mbed-emac-k64f>
        $<$<IN_LIST,K66F,INTERFACE_COMPILE_DEFINITIONS>mbed-emac-k66f>
)

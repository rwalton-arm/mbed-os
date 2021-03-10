# Copyright (c) 2020-2021 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

# List of all optional platform libraries available.
add_library(mbed-psa INTERFACE)

if("EXPERIMENTAL_API" IN_LIST MBED_TARGET_LABELS)
    add_subdirectory(FEATURE_EXPERIMENTAL_API)
endif()

add_subdirectory(cxxsupport)
add_subdirectory(mbed-trace)
add_subdirectory(randlib)
add_subdirectory(source)

target_include_directories(mbed-core
    INTERFACE
        include
        include/platform
        include/platform/internal
)


add_library(mbed-small-c-lib INTERFACE)

target_compile_definitions(mbed-small-c-lib
    INTERFACE
        MBED_RTOS_SINGLE_THREAD
        "$<$<CXX_COMPILER_ID:ARMClang>:__MICROLIB>"
        "$<$<CXX_COMPILER_ID:GNU>:__NEWLIB_NANO>"
)

target_link_options(mbed-small-c-lib
    INTERFACE
        "$<$<CXX_COMPILER_ID:ARMClang>:--library_type=microlib>"
        "$<$<CXX_COMPILER_ID:GNU>:--specs=nano.specs>"
)

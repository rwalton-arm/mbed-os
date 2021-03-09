# Copyright (c) 2020-2021 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

add_library(mbed-minimal-printf INTERFACE)

target_include_directories(mbed-minimal-printf
    INTERFACE
        .
)

target_sources(mbed-minimal-printf
    INTERFACE
        mbed_printf_armlink_overrides.c
        mbed_printf_implementation.c
        mbed_printf_wrapper.c
)

target_compile_definitions(mbed-minimal-printf
    INTERFACE
        MBED_MINIMAL_PRINTF
)

set(printf_gnu_link_options "")
list(APPEND printf_gnu_link_options
    "-Wl,--wrap,printf"
    "-Wl,--wrap,sprintf"
    "-Wl,--wrap,snprintf"
    "-Wl,--wrap,vprintf"
    "-Wl,--wrap,vsprintf"
    "-Wl,--wrap,vsnprintf"
    "-Wl,--wrap,fprintf"
    "-Wl,--wrap,vfprintf"
)

target_link_options(mbed-minimal-printf
    INTERFACE
    "$<$<CXX_COMPILER_ID:GNU>:${printf_gnu_link_options}>"
)

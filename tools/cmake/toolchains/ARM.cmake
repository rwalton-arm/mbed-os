# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set(CMAKE_ASM_COMPILER "armclang")
set(CMAKE_C_COMPILER "armclang")
set(CMAKE_CXX_COMPILER "armclang")
set(CMAKE_AR "armar")
set(CMAKE_OBJCOPY "fromelf")

# tell cmake about compiler targets.
# This will cause it to add the --target flag.
set(CMAKE_C_COMPILER_TARGET arm-arm-none-eabi)
set(CMAKE_CXX_COMPILER_TARGET arm-arm-none-eabi)

# Sets toolchain options
list(APPEND common_options
    "-mthumb"
    "-Wno-armcc-pragma-push-pop"
    "-Wno-armcc-pragma-anon-unions"
    "-Wno-reserved-user-defined-literal"
    "-Wno-deprecated-register"
    "-fdata-sections"
    "-fno-exceptions"
    "-fshort-enums"
    "-fshort-wchar"
)

list(APPEND asm_compile_options
    -masm=auto
    --target=arm-arm-none-eabi
)

list(APPEND link_options
    "--map"
)

# Add linking time preprocessor macro for TFM targets
if(MBED_CPU_CORE MATCHES "-NS$")
    list(APPEND link_options
        "--predefine=\"-DDOMAIN_NS=0x1\""
    )
endif()

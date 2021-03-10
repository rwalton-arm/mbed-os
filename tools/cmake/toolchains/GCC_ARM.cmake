# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set(CMAKE_ASM_COMPILER "arm-none-eabi-gcc")
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")
set(GCC_ELF2BIN "arm-none-eabi-objcopy")
set_property(GLOBAL PROPERTY ELF2BIN ${GCC_ELF2BIN})

# build toolchain flags that get passed to everything (including CMake compiler checks)
list(APPEND link_options
    "-Wl,--start-group"
        "-lstdc++"
        "-lsupc++"
        "-lm"
        "-lc"
        "-lgcc"
        "-lnosys"
    "-Wl,--end-group"
    "-specs=nosys.specs"
    "-Wl,--cref"
)

# Add linking time preprocessor macro for TFM targets
if("TFM" IN_LIST MBED_TARGET_LABELS)
    list(APPEND link_options
        "-DDOMAIN_NS=1"
    )
endif()

list(APPEND common_options
    "-Wall"
    "-Wextra"
    "-Wno-unused-parameter"
    "-Wno-missing-field-initializers"
    "-fmessage-length=0"
    "-fno-exceptions"
    "-ffunction-sections"
    "-fdata-sections"
    "-funsigned-char"
    "-fomit-frame-pointer"
    "-g3"
)

# Add linker flags to generate a mapfile with a given name
function(mbed_configure_memory_map target mapfile)
    target_link_options(${target}
        PRIVATE
            "-Wl,-Map=${mapfile}"
    )
endfunction()

# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

include(.mbedbuild/mbed_config.cmake)
include(${MBED_ROOT}/cmake/toolchain.cmake)
include(${MBED_ROOT}/cmake/core.cmake)
include(${MBED_ROOT}/cmake/profile.cmake)
include(${MBED_ROOT}/cmake/env.cmake)
include(${MBED_ROOT}/cmake/util.cmake)

# if the environment does not specify build type, set to Debug
if(NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE "RelWithDebInfo"
        CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
        FORCE)
endif()

# Create application executable
add_executable(app)

# Include Mbed OS main cmake
add_subdirectory(mbed-os)

# Link the example libs
target_link_libraries(app mbed-os)

# I have  to  leave this here as linker is processed after mbed-os added, and can't be in toolchain.cmake
# as its global symbol is empty at that stage, this needs more work
# TODO: This property + pre/post should be moved
get_property(linkerfile GLOBAL PROPERTY MBED_TARGET_LINKER_FILE)

# TODO: get project name to inject into ld
# TODO: @mbed-os-tools this pre/post build commands should get details from target + profile
if(MBED_TOOLCHAIN STREQUAL "GCC_ARM")
    # I have  to  leave this here as linker is processed after mbed-os added, and can't be in toolchain.cmake
    # as its global symbol is empty at that stage, this needs more work
    # TODO: This property  pre/post should be moved
    set(CMAKE_PRE_BUILD_COMMAND
        COMMAND "arm-none-eabi-cpp" -E -P
            -Wl,--gc-sections -Wl,--wrap,main -Wl,--wrap,_malloc_r -Wl,--wrap,_free_r
            -Wl,--wrap,_realloc_r -Wl,--wrap,_memalign_r -Wl,--wrap,_calloc_r
            -Wl,--wrap,exit -Wl,--wrap,atexit -Wl,-n
            -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
            -DMBED_ROM_START=0x0 -DMBED_ROM_SIZE=0x100000 -DMBED_RAM_START=0x20000000
            -DMBED_RAM_SIZE=0x30000 -DMBED_RAM1_START=0x1fff0000
            -DMBED_RAM1_SIZE=0x10000 -DMBED_BOOT_STACK_SIZE=1024
            -DXIP_ENABLE=0
            ${linkerfile} -o ${CMAKE_CURRENT_BINARY_DIR}/app.link_script.ld

        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/app.link_script.ld"
    )
elseif(MBED_TOOLCHAIN STREQUAL "ARM")
    set(CMAKE_PRE_BUILD_COMMAND COMMAND "")
    set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} --scatter=${linkerfile}")
endif()

# TODO: @mbed-os-tools this pre/post build commands should get details from target + profile
if(MBED_TOOLCHAIN STREQUAL "GCC_ARM")
    set(CMAKE_POST_BUILD_COMMAND
        COMMAND ${ELF2BIN} -O binary $<TARGET_FILE:app> $<TARGET_FILE:app>.bin
        COMMAND ${CMAKE_COMMAND} -E echo "-- built: $<TARGET_FILE:app>.bin"
        COMMAND ${ELF2BIN} -O ihex $<TARGET_FILE:app> $<TARGET_FILE:app>.hex
        COMMAND ${CMAKE_COMMAND} -E echo "-- built: $<TARGET_FILE:app>.hex"
    )
elseif(MBED_TOOLCHAIN STREQUAL "ARM")
    set(CMAKE_POST_BUILD_COMMAND
        COMMAND ${ELF2BIN} ${MBED_STUDIO_ARM_COMPILER} --bin  -o $<TARGET_FILE:app>.bin $<TARGET_FILE:app>
        COMMAND ${CMAKE_COMMAND} -E echo "-- built: $<TARGET_FILE:app>.bin"
        COMMAND ${ELF2BIN} ${MBED_STUDIO_ARM_COMPILER} --i32combined  -o $<TARGET_FILE:app>.hex $<TARGET_FILE:app>
        COMMAND ${CMAKE_COMMAND} -E echo "-- built: $<TARGET_FILE:app>.hex"
    )
endif()



# Custom pre/post build steps
add_custom_command(TARGET app PRE_LINK ${CMAKE_PRE_BUILD_COMMAND})
add_custom_command(TARGET app POST_BUILD ${CMAKE_POST_BUILD_COMMAND})

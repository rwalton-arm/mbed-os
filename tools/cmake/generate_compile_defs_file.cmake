# Copyright (c) 2021 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

#
# Generate a file containing compile definitions
#
# This function exists so we can pass the compile definitions to CPP when we
# preprocess the linker script for an mbed-target platform.
function(mbed_generate_options_for_linker target output_response_file_path)
    set(_compile_definitions
        "$<TARGET_PROPERTY:${target},INTERFACE_COMPILE_DEFINITIONS>"
    )

    # Remove macro definitions that contain spaces as the lack of escape sequences and quotation marks
    # in the macro when retrieved using generator expressions causes linker errors.
    # This includes string macros, array macros, and macros with operations.
    # TODO CMake: Add escape sequences and quotation marks where necessary instead of removing these macros.
    set(_compile_definitions
       "$<FILTER:${_compile_definitions},EXCLUDE, +>"
    )

    # Append -D to all macros as we pass these as response file to cxx compiler
    set(_compile_definitions
        "$<$<BOOL:${_compile_definitions}>:-D$<JOIN:${_compile_definitions}, -D>>"
    )
    file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/compile_time_defs.txt" CONTENT "${_compile_definitions}\n")
    set(${output_response_file_path} @${CMAKE_CURRENT_BINARY_DIR}/compile_time_defs.txt PARENT_SCOPE)
endfunction()


cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "windows_system_info")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "windows_system_info_plugin")

add_library(${PLUGIN_NAME} SHARED
  "windows_system_info_plugin.cpp"
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

set(CPUTEMP_DLL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/CpuTempWrapper/bin/Release/net8.0-windows/win-x64/publish")
set(LIBREHARDWARE_DLL "${CMAKE_CURRENT_SOURCE_DIR}/CpuTempWrapper/LibreHardwareMonitorLib.dll")

file(GLOB CPUTEMP_DLLS "${CPUTEMP_DLL_DIR}/*.dll")
if(EXISTS "${LIBREHARDWARE_DLL}")
    list(APPEND CPUTEMP_DLLS "${LIBREHARDWARE_DLL}")
endif()


foreach(dll_file ${CPUTEMP_DLLS})
    if(EXISTS "${dll_file}")
        get_filename_component(dll_name "${dll_file}" NAME)
        add_custom_command(TARGET ${PLUGIN_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${dll_file}"
                "$<TARGET_FILE_DIR:${PLUGIN_NAME}>/${dll_name}"
            COMMENT "Copying ${dll_name} to plugin build directory"
        )
    endif()
endforeach()


set(windows_system_info_bundled_libraries
    ${CPUTEMP_DLLS}
    PARENT_SCOPE
)

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} 
        -DOUTPUT_DIR=$<TARGET_FILE_DIR:${BINARY_NAME}>
        -P "${CMAKE_CURRENT_SOURCE_DIR}/copy_dlls.cmake"
    COMMENT "Copying CpuTempWrapper DLLs to runner output directory"
)
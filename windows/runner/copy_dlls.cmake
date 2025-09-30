# This file copies DLLs to the runner output directory
set(PLUGIN_DIR "${CMAKE_CURRENT_SOURCE_DIR}/..")
set(CPUTEMP_DLL_DIR "${PLUGIN_DIR}/CpuTempWrapper/bin/Release/net8.0-windows/win-x64/publish")
set(LIBREHARDWARE_DLL "${PLUGIN_DIR}/CpuTempWrapper/LibreHardwareMonitorLib.dll")

# Get all DLLs
file(GLOB CPUTEMP_DLLS "${CPUTEMP_DLL_DIR}/*.dll")
if(EXISTS "${LIBREHARDWARE_DLL}")
    list(APPEND CPUTEMP_DLLS "${LIBREHARDWARE_DLL}")
endif()

# Copy each DLL
foreach(dll_file ${CPUTEMP_DLLS})
    if(EXISTS "${dll_file}")
        get_filename_component(dll_name "${dll_file}" NAME)
        file(COPY "${dll_file}" DESTINATION "${OUTPUT_DIR}")
        message(STATUS "Copied ${dll_name} to ${OUTPUT_DIR}")
    endif()
endforeach()
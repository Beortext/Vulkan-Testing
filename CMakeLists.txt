# CMake 最低版本
cmake_minimum_required(VERSION 3.16)

#递归搜索文件
function(set_source_groups SOURCE_FILES SOURCE_DIR SOURCE_DIR_NAME)
    foreach(each_source_file IN LISTS SOURCE_FILES)
        get_filename_component(each_source_path "${each_source_file}" PATH)
        file(RELATIVE_PATH each_source_path_rel ${SOURCE_DIR} ${each_source_path})
        # 检查字符串是否为空 空的不分组
        if ("${each_source_path_rel}" STREQUAL "")
            source_group("${SOURCE_DIR_NAME}" FILES ${each_source_file})
            continue() 
        endif()
        string(REPLACE "/" "\\" each_source_group_path ${each_source_path_rel})
        source_group("${SOURCE_DIR_NAME}/${each_source_group_path}" FILES ${each_source_file})
    endforeach()
endfunction()


# 工程名
project(CabbageFramework)

#设置启动项
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT CabbageFramework)

# 设置C++标准
set(CMAKE_CXX_STANDARD 20)	# C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

#MSVC的C艹设置
if (MSVC)
    add_compile_options(/Zc:__cplusplus)
    add_compile_options(/Zc:preprocessor)
endif()

# 生成compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 设置Debug模式
set(CMAKE_BUILD_TYPE Release)

# 仅对 Visual Studio 编译器生效
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
    add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)
    add_definitions(-U_DEBUG)
    add_definitions(-DNDEBUG)
    add_definitions(-DNOMINMAX)
    add_compile_options(
        $<$<CONFIG:Debug>:/MD>
        $<$<CONFIG:Release>:/MD>
    )
endif() 

# 设置构建类型输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/${CMAKE_HOST_SYSTEM_PROCESSOR}/${CMAKE_BUILD_TYPE}/)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/build/${CMAKE_HOST_SYSTEM_NAME}/${CMAKE_HOST_SYSTEM_PROCESSOR}/${CMAKE_BUILD_TYPE}/)

# 设置目标输出目录
if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG})
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE})
endif()



# 设置源代码目录
set(SOURCE_DIR ${PROJECT_SOURCE_DIR}/SourceCode)


# 递归搜索源文件
file(GLOB_RECURSE SOURCE_FILES
    "${SOURCE_DIR}/*.*"
)

# 链接库
if (WIN32)
# 添加可执行文件
add_executable(${PROJECT_NAME} ${SOURCE_FILES})
set_source_groups("${SOURCE_FILES}" ${SOURCE_DIR} "SourceCode")

# 头文件目录
include_directories(
    ${PROJECT_SOURCE_DIR}/ExternalEnvironment/stb-image_v2.30
    ${PROJECT_SOURCE_DIR}/ExternalEnvironment/Vulkan_v1.3.290.0/Include/
    ${PROJECT_SOURCE_DIR}/ExternalEnvironment/glfw-3.4.bin.WIN64/include/
    ${PROJECT_SOURCE_DIR}/SourceCode/
)
target_link_directories(${PROJECT_NAME} PRIVATE
    ${PROJECT_SOURCE_DIR}/ExternalEnvironment/Vulkan_v1.3.290.0/Lib/Windows
    ${PROJECT_SOURCE_DIR}/ExternalEnvironment/glfw-3.4.bin.WIN64/lib-vc2022
)
target_link_libraries(${PROJECT_NAME} PRIVATE
    vulkan-1.lib
    spirv-cross-c.lib
    spirv-cross-core.lib
    spirv-cross-cpp.lib
    spirv-cross-c-shared.lib
    spirv-cross-glsl.lib
    spirv-cross-hlsl.lib
    spirv-cross-msl.lib
    spirv-cross-reflect.lib
    spirv-cross-util.lib
    glslang.lib
    glslang-default-resource-limits.lib
    GenericCodeGen.lib
    MachineIndependent.lib
    OSDependent.lib
    SPIRV.lib
    SPIRV-Tools.lib
    SPIRV-Tools-diff.lib
    SPIRV-Tools-link.lib
    SPIRV-Tools-lint.lib
    SPIRV-Tools-opt.lib
    SPIRV-Tools-reduce.lib
    SPIRV-Tools-shared.lib
    glfw3.lib
    glfw3dll.lib
    glfw3_mt.lib
)

# 拷贝相关库到目标输出目录
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${PROJECT_SOURCE_DIR}/ExternalEnvironment/Vulkan_v1.3.290.0/Bin/Windows/SPIRV-Tools-shared.dll
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${PROJECT_SOURCE_DIR}/TestCase
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/TestCase
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${PROJECT_SOURCE_DIR}/TestCase
    ${CMAKE_BINARY_DIR}/TestCase
)
endif()

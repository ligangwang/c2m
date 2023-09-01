cmake_minimum_required(VERSION 3.16)


set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_STANDARD 11)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(HAVE_FLAG_SEARCH_PATHS_FIRST 0)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)


project(c2m, VERSION 0.0.9 LANGUAGES CXX C) 

include_directories(
    ${CMAKE_SOURCE_DIR}/dep/include
)


find_package(LLVM 14 REQUIRED CONFIG)
message(STATUS "Found LLVM BIN ${LLVM_TOOLS_BINARY_DIR}")
execute_process(COMMAND llvm-config --libfiles
                OUTPUT_VARIABLE llvm_libfiles OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND llvm-config --system-libs
                OUTPUT_VARIABLE sys_libraries OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NOT ${sys_libraries} STREQUAL "")
  string(REPLACE " -llibxml2.tbd" "" sys_libraries ${sys_libraries})
  string(REPLACE " " ";" sys_libraries ${sys_libraries})
endif()
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Found LLVM libraries ${llvm_libfiles}")
message(STATUS "Found LLVM include dirs: ${LLVM_INCLUDE_DIRS}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
message(STATUS "Found SYS libraries ${sys_libraries}") 
if(WIN32)
  set(clang_lib libclang)
  message(STATUS, "Found Windows Kit: ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}")
  message(STATUS, "Found Windows Platform: ${CMAKE_VS_PLATFORM_TOOLSET_HOST_ARCHITECTURE}")
else()
  set(clang_lib clang)
endif(WIN32)

link_directories(
  ${LLVM_INCLUDE_DIRS}/../lib
  ${CMAKE_SOURCE_DIR}/dep/lib
)

add_executable(c2m
  src/cmodule.c
  src/c2m.c
)

target_include_directories(c2m PUBLIC
  ${LLVM_INCLUDE_DIRS}
)

target_link_libraries(c2m PRIVATE 
  mlrl 
  clib
  ${clang_lib}
  ${sys_libraries}
)

target_link_options(c2m PRIVATE -no-pie)

add_custom_command(
  TARGET c2m
  POST_BUILD
  COMMAND c2m -i/usr/include -o ${CMAKE_SOURCE_DIR}/mlib stdio.h
  COMMAND c2m -i/usr/include -o ${CMAKE_SOURCE_DIR}/mlib math.h
)

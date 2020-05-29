cmake_minimum_required(VERSION 3.2)

project(koheron_driver)


set(CMAKE_CONFIGURATION_TYPES "Release" CACHE STRING "" FORCE)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -flto -m32 -march=native -O3 -MMD -MP -Wall  -pthread")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -lm -static-libgcc -static-libstdc++ ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wpedantic -Wfloat-equal -Wunused-macros -Wcast-qual ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wlogical-op -Wdouble-promotion -Wformat -Wmissing-include-dirs -Wundef ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wcast-align -Wpacked -Wredundant-decls -Wvarargs -Wvector-operation-performance -Wswitch-default ")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wuninitialized -Wshadow -Wmissing-declarations ")
 
include_directories(../../../../server/client)
include_directories(../../../../server/context)
include_directories(../../../../server/core)
include_directories(../../../../server/drivers)
include_directories(../../../../)
include_directories(../)
include_directories(/usr/include)
include_directories(../../../../tmp/examples/mars_zx3/star-tracker/server/) # update this line to compile for different device

# create static library
add_library(kdriver SHARED driver.cpp)

# create shared library
add_library(kdriverStatic STATIC driver.cpp)
set_target_properties(kdriverStatic PROPERTIES OUTPUT_NAME kdriver)

set_target_properties(kdriver PROPERTIES COMPILE_OPTIONS "-m32" LINK_FLAGS "-m32")
#set_target_properties(kdriverStatic PROPERTIES COMPILE_OPTIONS "-m32" LINK_FLAGS "-m32")


cmake_minimum_required(VERSION 3.15)
project(NDGeoEff LANGUAGES CXX)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

option(NDGEOEFF_BUILD_STEP1 "Build step 1: hadron geometric efficiency" ON)
option(NDGEOEFF_BUILD_STEP3 "Build step 3: Etrim/PRISM analysis (requires ROOT + OscLib)" OFF)
option(NDGEOEFF_BUILD_PYTHON "Build the pyGeoEff Python bindings (needs pybind11 >= 2.10 for Python >= 3.11)" OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(-Wall -Wextra)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(PythonLibs REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})
include_directories(${CMAKE_SOURCE_DIR}/include)

message(STATUS "NDGeoEff source directory: ${CMAKE_SOURCE_DIR}")
message(STATUS "Include directories: ${CMAKE_SOURCE_DIR}/include")

if(NDGEOEFF_BUILD_PYTHON)
  find_package(pybind11 CONFIG QUIET)
  if(NOT pybind11_FOUND)
    add_subdirectory(pybind11)
  endif()
endif()

add_subdirectory(src)

if(NDGEOEFF_BUILD_STEP1)
  add_subdirectory(apps/step1_hadron_geoeff)
endif()

if(NDGEOEFF_BUILD_STEP3)
  add_subdirectory(apps/step3_etrim_analysis)
endif()

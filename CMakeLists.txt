
cmake_minimum_required(VERSION 3.10.1)

project(
  GPUTerrainProject
  VERSION 0.0.0
)

# set (CMAKE_LIBRARY_OUTPUT_DIRECTORY "$../build/realase")
# set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "$../build/realase")

# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "../build/debug/lib")
# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "../build/debug/lib")
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "../build/debug/bin")

# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "../build/realase/lib")
# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "../build/realase/lib")
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "../build/realase/bin")

SET(OUTPUT_LIBDIR ${PROJECT_BINARY_DIR}/lib)
SET(OUTPUT_BINDIR ${PROJECT_BINARY_DIR}/bin)

##################################################
# Set the output to one set of directories lib/ bin/
# Code from GPUEngine https://github.com/Rendering-FIT/GPUEngine
##################################################
FOREACH(CONF ${CMAKE_CONFIGURATION_TYPES})        # For each configuration (Debug, Release, MinSizeRel... and/or anything the user chooses)
   STRING(TOUPPER "${CONF}" CONF)                # Go uppercase (DEBUG, RELEASE...)
   SET("CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONF}" "${OUTPUT_LIBDIR}")
   SET("CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONF}" "${OUTPUT_BINDIR}")
   IF(WIN32)
       SET("CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONF}" "${OUTPUT_LIBDIR}")
   ELSE()
       SET("CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONF}" "${OUTPUT_LIBDIR}")
   ENDIF()
ENDFOREACH()

add_subdirectory(libs/GPUTerrain)
add_subdirectory(GPUTerrainDemo)

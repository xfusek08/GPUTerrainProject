
cmake_minimum_required(VERSION 3.10.1)

project(
  GPUTerrainProject
  VERSION 0.0.0
)

# set (CMAKE_LIBRARY_OUTPUT_DIRECTORY "$../build/realase")
# set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "$../build/realase")

# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "../build/debug/lib")
# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "../build/debug/lib")
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "../build/debug/dll")

# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "../build/realase/lib")
# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "../build/realase/lib")
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "../build/realase/dll")

add_subdirectory(libs/GPUTerrain)
add_subdirectory(GPUTerrainDemo)

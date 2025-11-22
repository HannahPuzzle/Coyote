cmake_minimum_required(VERSION 3.5)

project(00_building_for_enzian)
message("Hello from the CMake")

# Path to Coyote directory
set(CYT_DIR ${CMAKE_SOURCE_DIR}/../../../)

# Path to Coyote's internal CMake, which defines the custom build targets
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CYT_DIR}/cmake)
find_package(CoyoteHW REQUIRED)

# Shell configuration
set(FDEV_NAME "enzian")
set(EN_PR 0)            

# Validate the configuration
validation_checks_hw()

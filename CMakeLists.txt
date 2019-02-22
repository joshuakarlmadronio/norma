cmake_minimum_required (VERSION 2.8.4)
project(norma)

file(GLOB SOURCES "*.cpp")

add_executable(norma ${SOURCES})
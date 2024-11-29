cmake_minimum_required(VERSION 3.22)
get_filename_component(PROJECT_NAME ${CMAKE_SOURCE_DIR} NAME_WE)
project(${PROJECT_NAME} LANGUAGES C CXX ASM)

set(CWD ${CMAKE_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CWD}/cmake)
set(INC ${CWD}/inc)
set(SRC ${CWD}/src)
set(TMP ${CWD}/tmp)

file(GLOB_RECURSE A
    "${SRC}/*.s*"
    "${SRC}/${OS}/*.s*"
)
file(GLOB_RECURSE C
    "${SRC}/*.c*"
    "${SRC}/${OS}/*.c*"
    "${SRC}/gui/*.c*"
)
file(GLOB_RECURSE H
    "${INC}/*.h*"
    "${SRC}/${OS}/*.h*"
    "${SRC}/gui/*.h*"
)

include_directories(
    ${INC} ${INC}/${OS} ${INC}/gui ${TMP}
)

add_compile_definitions(
    "OS=${OS}"
)

find_package(FLEX  REQUIRED)
find_package(BISON REQUIRED)

file(GLOB L CONFIGURE_DEPENDS ${SRC}/*.lex)
file(GLOB Y CONFIGURE_DEPENDS ${SRC}/*.yacc)
get_filename_component(lex  ${L} NAME_WE)
get_filename_component(yacc ${Y} NAME_WE)
 FLEX_TARGET(lex  ${L} ${TMP}/${lex}.lexer.cpp)
BISON_TARGET(yacc ${Y} ${TMP}/${yacc}.parser.cpp
          DEFINES_FILE ${TMP}/${yacc}.parser.hpp)

find_package(SDL2 REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)

add_executable(${CMAKE_PROJECT_NAME}
    ${C} ${H} ${A}
    ${FLEX_lex_OUTPUTS} ${BISON_yacc_OUTPUTS}
)

target_link_libraries(${PROJECT_NAME} SDL2::SDL2)

install(TARGETS ${PROJECT_NAME})

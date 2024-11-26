# host compiler
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_BUILD_TYPE  Debug)
set(TOOLCHAIN_PREFIX  x86_64-w64-mingw32)

# target environment on the build host system
#   set 1st to dir with the cross compiler's C/C++ headers/libs
set(CMAKE_FIND_ROOT_PATH C:/msys64/mingw64)
set(CMAKE_MAKE_PROGRAM ${CMAKE_FIND_ROOT_PATH}/bin/mingw32-makez)

# cross compilers to use for C and C++
set(CMAKE_ASM_COMPILER ${CMAKE_FIND_ROOT_PATH}/bin/${TOOLCHAIN_PREFIX}-as)
set(CMAKE_C_COMPILER   ${CMAKE_FIND_ROOT_PATH}/bin/${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${CMAKE_FIND_ROOT_PATH}/bin/${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_RC_COMPILER  ${CMAKE_FIND_ROOT_PATH}/bin/${TOOLCHAIN_PREFIX}-windres)

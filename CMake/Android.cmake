# Based on https://github.com/compnerd/swift-build/blob/master/cmake/caches/android-x86_64.cmake

set(CMAKE_SYSTEM_NAME "Android" CACHE STRING "")
set(CMAKE_SYSTEM_VERSION $ENV{ANDROID_TARGET_ABI} CACHE STRING "")

set(CMAKE_ANDROID_API $ENV{ANDROID_TARGET_ABI} CACHE STRING "")
set(CMAKE_ANDROID_ARCH_ABI $ENV{ANDROID_TARGET_ARCHITECTURE} CACHE STRING "")

set(CMAKE_ANDROID_NDK $ENV{ANDROID_NDK_HOME} CACHE FILEPATH
  "Absolute path to the root directory of the NDK")

set(CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION "clang" CACHE STRING "")
set(CMAKE_ANDROID_STL_TYPE "c++_static" CACHE STRING "")

set(ANDROID_ABI ${CMAKE_ANDROID_ARCH_ABI} CACHE STRING "")
set(ANDROID_NDK ${CMAKE_ANDROID_NDK} CACHE STRING "")
set(ANDROID_PLATFORM android-${CMAKE_ANDROID_API} CACHE STRING "")
set(ANDROID_STL ${CMAKE_ANDROID_STL_TYPE} CACHE STRING "")


SET(CMAKE_SYSROOT "${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/x86_64-linux-android")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/x86_64-linux-android")

# Based on https://github.com/compnerd/swift-build/blob/master/cmake/caches/android-x86_64-swift-flags.cmake

set(CMAKE_SWIFT_COMPILER_TARGET x86_64-unknown-linux-android CACHE STRING "")
set(CMAKE_SWIFT_FLAGS
      -resource-dir ${CMAKE_Swift_SDK}/usr/lib/swift
      -Xcc --sysroot=${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot
    CACHE STRING "")
set(CMAKE_SWIFT_LINK_FLAGS
      -resource-dir ${CMAKE_Swift_SDK}/usr/lib/swift
      -tools-directory ${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin
      -Xclang-linker --gcc-toolchain=${CMAKE_ANDROID_NDK}/toolchains/x86_64-4.9/prebuilt/linux-x86_64
      -Xclang-linker --sysroot=${CMAKE_ANDROID_NDK}/platforms/android-${CMAKE_ANDROID_API}/arch-x86_64
      -Xclang-linker -fuse-ld=gold
    CACHE STRING "")

if(CMAKE_VERSION VERSION_LESS 3.16)
  list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES CMAKE_Swift_COMPILER_TARGET)
endif()
set(CMAKE_Swift_COMPILER_TARGET x86_64-unknown-linux-android CACHE STRING "")
set(CMAKE_Swift_FLAGS "-resource-dir ${CMAKE_Swift_SDK}/usr/lib/swift -Xcc --sysroot=${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot -Xclang-linker --gcc-toolchain=${CMAKE_ANDROID_NDK}/toolchains/x86_64-4.9/prebuilt/linux-x86_64 -Xclang-linker -fuse-ld=gold -Xclang-linker --sysroot=${CMAKE_ANDROID_NDK}/platforms/android-${CMAKE_ANDROID_API}/arch-x86_64" CACHE STRING "")

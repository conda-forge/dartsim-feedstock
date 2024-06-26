#!/bin/sh

mkdir build && cd build

if [ ${target_platform} == "linux-ppc64le" ]; then
  # Disable tests
  CMAKE_TEST_CMD=-DBUILD_TESTING:BOOL=OFF
  NUM_PARALLEL=-j1
else
  CMAKE_TEST_CMD=-DBUILD_TESTING:BOOL=ON
  NUM_PARALLEL=-j${CPU_COUNT}
fi

# Disable SIMD for linux-ppc64le, linux_aarch64, and any OSX platform; enable for other platforms
if [ "${target_platform}" == "linux-ppc64le" ] ||
  [ "${target_platform}" == "linux_aarch64" ] ||
  [[ "${target_platform}" == osx-* ]]; then
  DART_ENABLE_SIMD=OFF
else
  DART_ENABLE_SIMD=ON
fi

if [[ "${target_platform}" == osx-* ]]; then
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake ${CMAKE_ARGS} $SRC_DIR \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DDART_VERBOSE:BOOL=ON \
  -DDART_TREAT_WARNINGS_AS_ERRORS:BOOL=OFF \
  -DDART_ENABLE_SIMD:BOOL=${DART_ENABLE_SIMD} \
  -DDART_BUILD_DARTPY:BOOL=OFF \
  -DDART_USE_SYSTEM_IMGUI:BOOL=ON \
  ${CMAKE_TEST_CMD}

make ${NUM_PARALLEL}
make ${NUM_PARALLEL} install

if [ ${target_platform} != "linux-ppc64le" ]; then
  make ${NUM_PARALLEL} tests
  if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    ctest --output-on-failure
  fi
fi

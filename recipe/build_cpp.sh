#!/bin/sh

mkdir build && cd build

if [[ ${target_platform} == "linux-ppc64le" ]]; then
  NUM_PARALLEL=-j2
elif [[ ${target_platform} == "linux-aarch64" ]]; then
  NUM_PARALLEL=-j2
elif [[ ${target_platform} == linux-* ]]; then
  if [[ ${CPU_COUNT} -gt 8 ]]; then
    NUM_PARALLEL=-j8
  elif [[ ${CPU_COUNT} -lt 4 ]]; then
    NUM_PARALLEL=-j4
  else
    NUM_PARALLEL=-j${CPU_COUNT}
  fi
else
  if [[ ${CPU_COUNT} -gt 8 ]]; then
    NUM_PARALLEL=-j8
  else
    NUM_PARALLEL=-j${CPU_COUNT}
  fi
fi

if [[ "${target_platform}" == osx-* ]]; then
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake ${CMAKE_ARGS} $SRC_DIR \
  -DCMAKE_BUILD_TYPE=Release \
  -DDART_VERBOSE:BOOL=ON \
  -DDART_TREAT_WARNINGS_AS_ERRORS:BOOL=OFF \
  -DDART_ENABLE_SIMD:BOOL=OFF \
  -DDART_BUILD_GUI_OSG:BOOL=ON \
  -DDART_BUILD_DARTPY:BOOL=OFF \
  -DDART_USE_SYSTEM_IMGUI:BOOL=ON

make ${NUM_PARALLEL}
make ${NUM_PARALLEL} install

if [ ${target_platform} != "linux-ppc64le" ]; then
  make ${NUM_PARALLEL} tests
  if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    ctest --output-on-failure
  fi
fi

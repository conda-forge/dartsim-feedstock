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



cmake ${CMAKE_ARGS} $SRC_DIR \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DDART_VERBOSE:BOOL=ON \
      ${CMAKE_TEST_CMD}

make ${NUM_PARALLEL}
make ${NUM_PARALLEL} install

if [ ${target_platform} != "linux-ppc64le" ]; then
  make ${NUM_PARALLEL} tests
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
  ctest --output-on-failure -E "test_Collision"
fi
fi

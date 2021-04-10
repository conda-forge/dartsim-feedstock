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



cmake $SRC_DIR \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      # To ensure that OpenGL is not accidentally found on macOS
      -DDART_SKIP_OpenGL:BOOL=ON \
      ${CMAKE_TEST_CMD}

make ${NUM_PARALLEL}
make ${NUM_PARALLEL} install

if [ ${target_platform} != "linux-ppc64le" ]; then
  make ${NUM_PARALLEL} tests
  ctest --output-on-failure -E "test_Collision"
fi

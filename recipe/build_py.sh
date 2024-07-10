#!/bin/sh

# Set CMAKE_BUILD_PARALLEL_LEVEL to control the parallel build level
if [[ ${target_platform} == "linux-ppc64le" ]]; then
  export CMAKE_BUILD_PARALLEL_LEVEL=1
else
  if [[ ${CPU_COUNT} -gt 8 ]]; then
    export CMAKE_BUILD_PARALLEL_LEVEL=8
  else
    export CMAKE_BUILD_PARALLEL_LEVEL=${CPU_COUNT}
  fi
fi

# Install the Python package
python -m pip install .

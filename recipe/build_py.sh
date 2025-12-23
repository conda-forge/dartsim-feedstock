#!/bin/sh

set -euxo pipefail

# Set architecture-specific options for macOS
if [[ "${target_platform}" == osx-* ]]; then
  if [[ "${target_platform}" == osx-arm64 ]]; then
    echo "Building for macOS ARM (Apple Silicon)"
    export ARCHFLAGS="-arch arm64"
  else
    echo "Building for macOS Intel (x86_64)"
    export ARCHFLAGS="-arch x86_64"
  fi
fi

# Set CMAKE_BUILD_PARALLEL_LEVEL to control the parallel build level
if [[ ${target_platform} == "linux-ppc64le" ]]; then
  export CMAKE_BUILD_PARALLEL_LEVEL=2
else
  if [[ ${CPU_COUNT} -gt 8 ]]; then
    export CMAKE_BUILD_PARALLEL_LEVEL=8
  else
    export CMAKE_BUILD_PARALLEL_LEVEL=${CPU_COUNT}
  fi
fi

# Install the Python package
python -m pip install . -vv

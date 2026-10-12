#!/usr/bin/env bash

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
  # DART 6.20 uses std::pmr; see https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

# Set CMAKE_BUILD_PARALLEL_LEVEL to control the parallel build level
if [[ ${target_platform} == "linux-ppc64le" ]]; then
  export CMAKE_BUILD_PARALLEL_LEVEL=2
elif [[ ${target_platform} == "linux-aarch64" ]]; then
  export CMAKE_BUILD_PARALLEL_LEVEL=2
elif [[ ${target_platform} == linux-* ]]; then
  if [[ ${CPU_COUNT} -gt 8 ]]; then
    export CMAKE_BUILD_PARALLEL_LEVEL=8
  elif [[ ${CPU_COUNT} -lt 4 ]]; then
    export CMAKE_BUILD_PARALLEL_LEVEL=4
  else
    export CMAKE_BUILD_PARALLEL_LEVEL=${CPU_COUNT}
  fi
else
  if [[ ${CPU_COUNT} -gt 8 ]]; then
    export CMAKE_BUILD_PARALLEL_LEVEL=8
  else
    export CMAKE_BUILD_PARALLEL_LEVEL=${CPU_COUNT}
  fi
fi

# Install the Python package
export CMAKE_GENERATOR=Ninja
export CMAKE_ARGS="${CMAKE_ARGS:-} -DDART_USE_SYSTEM_PYBIND11=ON -DPYBIND11_FINDPYTHON=OFF -DBUILD_TESTING=OFF"
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  python -m pip install . -vv
else
  python -m pip install . -vv --no-deps --no-build-isolation
fi

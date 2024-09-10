#!/bin/sh

set -euxo pipefail

# Detect architecture and platform
ARCH=$(uname -m)
OS=$(uname)

# Set architecture-specific options for macOS
if [[ "$OS" == "Darwin" ]]; then
  case "$ARCH" in
  arm64)
    echo "Building for macOS ARM (Apple Silicon)"
    export ARCHFLAGS="-arch arm64"
    ;;
  x86_64)
    echo "Building for macOS Intel (x86_64)"
    export ARCHFLAGS="-arch x86_64"
    ;;
  *)
    echo "Unknown macOS architecture: $ARCH"
    exit 1
    ;;
  esac
else
  echo "Building for other OS: $OS $ARCH"
  export ARCHFLAGS=""
fi

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
python -m pip install . -vv

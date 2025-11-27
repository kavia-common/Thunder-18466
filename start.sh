#!/usr/bin/env bash
# Start script for Thunder-18466 backend service.
# This script ensures a consistent start command for CI/CD and container runtimes.

set -euo pipefail

# Build the project if needed. If already built, this should be fast/no-op.
# Note: Requires cmake and a standard build toolchain available in the container.
BUILD_DIR="${BUILD_DIR:-build}"

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

if [ ! -f "build.ninja" ] && [ ! -f "Makefile" ]; then
  cmake .. -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE:-Release}"
fi

# Prefer Ninja if present, otherwise use make
if command -v ninja >/dev/null 2>&1 && [ -f "build.ninja" ]; then
  ninja
else
  make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)"
fi

# Locate the main service binary.
# Adjust binary name if the project generates a different executable target.
# We attempt common target names seen in Thunder/WPEFramework-like repos.
CANDIDATES=(
  "Thunder"
  "WPEFramework"
  "thunder"
  "wpeframework"
)

SERVICE_BIN=""
for c in "${CANDIDATES[@]}"; do
  if [ -x "./${c}" ]; then
    SERVICE_BIN="./${c}"
    break
  fi
  if [ -x "./bin/${c}" ]; then
    SERVICE_BIN="./bin/${c}"
    break
  fi
  if [ -x "./Source/${c}/${c}" ]; then
    SERVICE_BIN="./Source/${c}/${c}"
    break
  fi
done

if [ -z "${SERVICE_BIN}" ]; then
  echo "ERROR: Could not locate the Thunder-18466 backend service binary after build." >&2
  echo "Searched candidates: ${CANDIDATES[*]}" >&2
  echo "Please verify the executable target name and update start.sh accordingly." >&2
  exit 1
fi

echo "Starting Thunder-18466 backend service: ${SERVICE_BIN}"
exec "${SERVICE_BIN}"

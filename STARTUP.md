# Thunder-18466 - Startup

This container uses `start.sh` as the canonical entrypoint for starting the backend service. It performs:
- Configure and build the project using CMake (Release by default).
- Run the generated backend service executable.

## Usage

- Local:
  bash ./start.sh

- With Procfile-compatible runners:
  The provided `Procfile` contains:
  web: bash ./start.sh

## Environment Variables

- BUILD_DIR (optional): Directory for out-of-source builds. Default: build
- CMAKE_BUILD_TYPE (optional): CMake build type. Default: Release

Note: Do not hardcode secrets or environment configuration in scripts. Use the .env managed by the orchestrator. If the service requires additional environment variables, list them here and in a `.env.example` file (but do not create `.env` in code).

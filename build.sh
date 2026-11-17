#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_DIR="${ROOT}/containers/${1:?Usage: bash build.sh CONTAINER}"
source "${CONTAINER_DIR}/params.sh"
NEUROCONTAINERS_ROOT="${ROOT}/build/neurocontainers"
git init -q "${NEUROCONTAINERS_ROOT}"
git -C "${NEUROCONTAINERS_ROOT}" fetch -q --depth=1 \
    https://github.com/neurodesk/neurocontainers.git \
    5fc5675e94f6148ec5e9c8f766a57dba330ef51d
git -C "${NEUROCONTAINERS_ROOT}" checkout -q --detach FETCH_HEAD
mkdir -p "${NEUROCONTAINERS_ROOT}/recipes/${toolName}"
cp "${CONTAINER_DIR}/"* "${NEUROCONTAINERS_ROOT}/recipes/${toolName}/"
cd "${NEUROCONTAINERS_ROOT}"
uv run --python 3.13 --locked sf-build "${toolName}" --architecture x86_64
uv run --python 3.13 --no-sync sf-test "${toolName}" --architecture x86_64 --offline-mode

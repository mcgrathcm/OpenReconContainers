#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER="${1:?Usage: bash package.sh CONTAINER}"
CONTAINER_DIR="${ROOT}/containers/${CONTAINER}"
source "${CONTAINER_DIR}/params.sh"
command -v uv >/dev/null
command -v 7z >/dev/null
bash "${ROOT}/build.sh" "${CONTAINER}"
BUILD_DIR="${ROOT}/build/package/${CONTAINER}"
VENV="${ROOT}/build/package-venv"
if [ ! -x "${VENV}/bin/python" ]; then
    uv venv --python 3.13 --seed "${VENV}"
fi
uv pip install --python "${VENV}/bin/python" -r "${ROOT}/packaging/requirements.txt"
source "${VENV}/bin/activate"
RECIPE="${BUILD_DIR}/recipes/${toolName}"
DIST="${ROOT}/dist/${CONTAINER}"
mkdir -p "${RECIPE}" "${DIST}"
cp "${ROOT}/vendor/openrecon/recipes/"*.py "${BUILD_DIR}/recipes/"
cp "${ROOT}/vendor/openrecon/recipes/"{build.sh,OpenReconSchema_1.1.0.json} "${BUILD_DIR}/recipes/"
cp "${CONTAINER_DIR}/OpenReconLabel.json" "${RECIPE}/"
cp "${CONTAINER_DIR}/OpenReconREADME.md" "${RECIPE}/README.md"
cp "${CONTAINER_DIR}/params.sh" "${RECIPE}/"
uv run --no-project --python "${VENV}/bin/python" "${ROOT}/packaging/make_docs.py" \
    "${RECIPE}/README.md" "${RECIPE}/docs.pdf"
case "$(docker info --format '{{.Architecture}}')" in
    arm64|aarch64) export OPENRECON_DIND_PLATFORM=linux/arm64 ;;
    *) export OPENRECON_DIND_PLATFORM=linux/amd64 ;;
esac
docker pull --platform "${OPENRECON_DIND_PLATFORM}" docker:24.0-dind
(
    cd "${RECIPE}"
    CI=1 BUILD_PACKAGE_SELECTION=openrecon BUILD_PACKAGE_SELECTION_OVERRIDE=1 \
        bash ../build.sh --local-cache --ignore-mdpdf
)
VENDOR=$(uv run --no-project --python "${VENV}/bin/python" python -c \
    'import json, sys; print(json.load(open(sys.argv[1]))["general"]["vendor"])' \
    "${CONTAINER_DIR}/OpenReconLabel.json")
ASSET="OpenRecon_${VENDOR}_${toolName}_V${version}"
cp "${RECIPE}/openrecon/${ASSET}.zip" "${DIST}/"
cp "${RECIPE}/docs.pdf" "${DIST}/${ASSET}.pdf"

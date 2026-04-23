#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
##
# @file prepare_encoder.sh
# @brief Download the encoder archive and place json.hpp at the project root.
# @usage ./prepare_encoder.sh <build_dir> <version>

set -e
TARGET=$1
TARGET_VERSION=$2
TAR_PREFIX=encoder
TAR_NAME=${TAR_PREFIX}-${TARGET_VERSION}.tar.gz
URL="https://github.com/nnstreamer/nnstreamer-android-resource/raw/main/external/${TAR_NAME}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "PREPARING Encoder at ${TARGET}"

[ ! -d "${TARGET}" ] && mkdir -p "${TARGET}"

pushd "${TARGET}" > /dev/null

_download_encoder() {
  [ -f "$TAR_NAME" ] && echo "${TAR_NAME} exists, skip downloading" && return 0
  echo "[Encoder] downloading ${TAR_NAME}"
  if ! wget -q "${URL}"; then
    echo "[Encoder] Download failed, please check url"
    exit 1
  fi
  echo "[Encoder] Finish downloading encoder"
}

_untar_encoder() {
  echo "[Encoder] untar encoder"
  tar -zxvf "${TAR_NAME}" -C "${TARGET}"
  rm -f "${TAR_NAME}"

  if [ "${TARGET_VERSION}" = "0.2" ]; then
    cp -f json.hpp "${PROJECT_ROOT}/"
    echo "[Encoder] Copied json.hpp to ${PROJECT_ROOT}/"
  fi
}

[ ! -d "${TAR_PREFIX}" ] && _download_encoder && _untar_encoder

popd > /dev/null

#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${PRJ_ROOT_PATH}"; echo + cd "${PWD}"

eval $(cat .env) yarn

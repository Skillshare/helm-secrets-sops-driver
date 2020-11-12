#!/usr/bin/env bash

set -euo pipefail

main() {
	local helm="${HELM_BIN:-helm}"

	export HELM_SECRETS_DRIVER="${HELM_PLUGIN_DIR}/lib/sk-sops.sh"

	exec "${helm}" "$@"
}

main "$@"

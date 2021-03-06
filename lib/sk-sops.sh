# XXX: copied from https://raw.githubusercontent.com/jkroepke/helm-secrets/master/scripts/drivers/sops.sh
# This is a helm-secrets driver that implements our "skips assume role" workaround.

_SOPS="${HELM_SECRETS_SOPS_BIN:-sops}"

driver_is_file_encrypted() {
	input="${1}"

	grep -q 'sops:' "${input}" && grep -q 'version:' "${input}"
}

driver_encrypt_file() {
	type="${1}"
	input="${2}"
	output="${3}"

	if [ "${input}" = "${output}" ]; then
		$_SOPS --encrypt --input-type "${type}" --output-type "${type}" --in-place "${input}"
	else
		$_SOPS --encrypt --input-type "${type}" --output-type "${type}" --output "${output}" "${input}"
	fi
}

driver_decrypt_file() {
	type="${1}"
	input="${2}"
	# if omit then output to stdout
	output="${3:-}"

	scratch="$(mktemp)"

	if [ "${SOPS_SKIP_KMS_ASSUME_ROLE:-}" = "1" ] || [ "${SOPS_SKIP_KMS_ASSUME_ROLE:-}" = "true" ]; then
		grep -vF 'role: arn:aws:iam::' "${input}" >"${scratch}"
	else
		cp "${input}" "${scratch}"
	fi

	if [ "${output}" != "" ]; then
		$_SOPS --decrypt --input-type "${type}" --output-type "${type}" --output "${output}" "${scratch}"
	else
		$_SOPS --decrypt --input-type "${type}" --output-type "${type}" "${scratch}"
	fi
}

driver_edit_file() {
	type="${1}"
	input="${2}"

	$_SOPS --input-type yaml --output-type yaml "${input}"
}

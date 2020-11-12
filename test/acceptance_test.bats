#!/usr/bin/env bats

load vendor/bats-support/load
load vendor/bats-assert/load

setup() {
	export HELM_BIN=./test/bin/helm
	export HELM_PLUGIN_DIR=${PWD}
}

@test 'sets SECRET_DRIVER' {
	run lib/run.sh
	assert_success
	assert_output --partial "HELM_SECRET_DRIVER=${HELM_PLUGIN_DIR}/lib/sk-sops.sh"
}

@test 'forwards arguments' {
	run lib/run.sh --foo --bar
	assert_success
	assert_output --partial --foo
	assert_output --partial --bar
}

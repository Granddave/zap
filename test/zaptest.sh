#!/bin/bash

set -eu

export ZAP_TEST_DIR
ZAP_TEST_DIR="$(mktemp -d --suffix='ZAP')" # TODO: handle error
export ZAP_TEST_FAIL=0
export ZAP_TEST_FAIL_MSG=""

fail() {
    local rc="$1"
    local message="$2"
    if [ "$rc" -ne 0 ]; then
        ZAP_TEST_FAIL=1
        ZAP_TEST_FAIL_MSG="$message"
        exit "$rc"
    fi
}

success() {
    echo "TEST OK: $TEST_CASE"
}

_git_clone() {
    case "$1" in
    "remote_git_repo") ;;

    \
        "*")
        echo "git: unknown clone arguments: $*"
        exit 1
        ;;
    esac
}

_hijack_git() {
    git() {
        local command="$1"
        case "$command" in
        "clone")
            shift
            _git_clone "$@"
            ;;
        "*")
            echo "git: unknown command: $1"
            exit 1
            ;;
        esac
    }
}

setup() {
    _hijack_git
}

teardown() {
    rm -rf "$ZAP_TEST_DIR"
    if [ "$ZAP_TEST_FAIL" -eq 1 ]; then
        echo "TEST NOK: $ZAP_TEST_CASE: $ZAP_TEST_FAIL_MSG"
    else
        echo "TEST OK: $ZAP_TEST_CASE"
    fi
}

setup
trap teardown EXIT

# vim: ft=bash ts=4 et

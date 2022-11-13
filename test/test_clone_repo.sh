#!/bin/bash
# shellcheck disable=SC1091
source zaptest.sh
export ZAP_TEST_CASE="Clone_and_verify_variable_declaration"

git clone
source "$ZAP_TEST_DIR"/repo_1/test.zsh
[ -n "$test_var" ] || fail $? "Variable test_var was not declared"
[ "$test_var" -eq 1 ] || fail $? "\$test_var != 1: $test_var"

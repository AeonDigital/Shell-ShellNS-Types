#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_function" "shellNS_types_check_function_test"

shellNS_types_check_function_test() {
  utestTestResult=$(shellNS_types_check_function "nonExists"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_function "shellNS_types_check_function_test"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

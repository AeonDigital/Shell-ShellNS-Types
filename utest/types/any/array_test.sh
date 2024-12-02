#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_any_array" "shellNS_types_check_any_array_test"

shellNS_types_check_any_array_test() {
  utestTestResult=$(shellNS_types_check_any_array "notAnArray"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal



  unset testArray
  declare -a testArray=()

  utestTestResult=$(shellNS_types_check_any_array "testArray"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal



  unset testArray
  declare -A testArray=()

  utestTestResult=$(shellNS_types_check_any_array "testArray"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal
}
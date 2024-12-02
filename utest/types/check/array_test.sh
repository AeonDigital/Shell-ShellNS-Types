#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_array" "shellNS_types_check_array_test"

shellNS_types_check_array_test() {
  unset testArray
  declare -a testArray=()

  utestTestResult=$(shellNS_types_check_array "testArray"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal



  unset testAssocArray
  declare -A testAssocArray

  utestTestResult=$(shellNS_types_check_array "testAssocArray"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal



  unset testVar
  local testVar="test"

  utestTestResult=$(shellNS_types_check_array "testVar"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

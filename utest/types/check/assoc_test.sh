#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_assoc" "shellNS_types_check_assoc_test"

shellNS_types_check_assoc_test() {
  unset testArray
  declare -a testArray=()

  utestTestResult=$(shellNS_types_check_assoc "testArray"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  unset testAssocArray
  declare -A testAssocArray

  utestTestResult=$(shellNS_types_check_assoc "testAssocArray"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  unset testVar
  local testVar="test"

  utestTestResult=$(shellNS_types_check_assoc "testVar"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_type" "shellNS_types_check_type_test"

shellNS_types_check_type_test() {
  utestTestResult=$(shellNS_types_check_type "int"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_type "float"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_type "?float"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_type "not-exist"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_type "int|float"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}
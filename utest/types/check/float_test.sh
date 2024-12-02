#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_float" "shellNS_types_check_float_test"

shellNS_types_check_float_test() {
  utestTestResult=$(shellNS_types_check_float "987654398.7"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_float "-9876543.987"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_float "9876543,987"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_float "987-6543.987"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

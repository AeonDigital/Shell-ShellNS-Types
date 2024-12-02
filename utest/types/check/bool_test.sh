#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_bool" "shellNS_types_check_bool_test"

shellNS_types_check_bool_test() {
  utestTestResult=$(shellNS_types_check_bool "1"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_bool "0"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_bool "-1"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_bool "-0"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_bool "2"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_minute" "shellNS_types_check_minute_test"

shellNS_types_check_minute_test() {
  utestTestResult=$(shellNS_types_check_minute "00:00"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_minute "23:59"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_minute "23:593"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_hour" "shellNS_types_check_hour_test"

shellNS_types_check_hour_test() {
  utestTestResult=$(shellNS_types_check_hour "00:00:00"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_hour "23:59:59"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_hour "23:59:60"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

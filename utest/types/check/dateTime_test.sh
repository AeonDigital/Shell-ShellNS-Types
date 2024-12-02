#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_dateTime" "shellNS_types_check_dateTime_test"

shellNS_types_check_dateTime_test() {
  utestTestResult=$(shellNS_types_check_dateTime "2024-02-29 00:00:00"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_dateTime "2024-02-29 12:30:30"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_dateTime "2024-02-29 23:59:60"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_dateTime "2023-02-29 00:00:00"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

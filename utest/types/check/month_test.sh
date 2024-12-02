#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_month" "shellNS_types_check_month_test"

shellNS_types_check_month_test() {
  utestTestResult=$(shellNS_types_check_month "2024-01"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_month "2024-12"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_month "2024-00"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}
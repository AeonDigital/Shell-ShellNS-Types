#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_date" "shellNS_types_check_date_test"

shellNS_types_check_date_test() {
  utestTestResult=$(shellNS_types_check_date "2024-02-29"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_date "2023-02-29"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

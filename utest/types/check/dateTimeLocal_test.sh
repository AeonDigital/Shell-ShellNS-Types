#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_dateTimeLocal" "shellNS_types_check_dateTimeLocal_test"

shellNS_types_check_dateTimeLocal_test() {
  utestTestResult=$(shellNS_types_check_dateTimeLocal "2024-02-29T12:30:30Z"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_dateTimeLocal "2024-02-29 12:30:30Z"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_dateTimeLocal "2024-02-29T12:30:30"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_dateTimeLocal "2024-02-29 12:30:30"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

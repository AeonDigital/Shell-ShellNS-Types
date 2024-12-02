#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_int" "shellNS_types_check_int_test"

shellNS_types_check_int_test() {
  utestTestResult=$(shellNS_types_check_int "9876543987"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_int "-9876543987"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_int "9876543.987"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_int "987-6543987"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

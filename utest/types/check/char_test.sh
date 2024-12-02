#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_char" "shellNS_types_check_char_test"

shellNS_types_check_char_test() {
  utestTestResult=$(shellNS_types_check_char "a"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_char "á"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_char "ab"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_char "1"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_char 1; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_char 12; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

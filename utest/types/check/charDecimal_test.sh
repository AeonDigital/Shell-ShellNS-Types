#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_charDecimal" "shellNS_types_check_charDecimal_test"

shellNS_types_check_charDecimal_test() {
  utestTestResult=$(shellNS_types_check_charDecimal "105"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charDecimal "195 173"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charDecimal "a"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charDecimal 1; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charDecimal 12b; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_charOctal" "shellNS_types_check_charOctal_test"

shellNS_types_check_charOctal_test() {
  utestTestResult=$(shellNS_types_check_charOctal "151"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charOctal "303 255"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charOctal 151; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charOctal 012; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charOctal 2; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charOctal 1512; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

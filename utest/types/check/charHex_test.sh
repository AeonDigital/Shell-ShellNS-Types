#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_charHex" "shellNS_types_check_charHex_test"

shellNS_types_check_charHex_test() {
  utestTestResult=$(shellNS_types_check_charHex "69"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charHex "C3 AD"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charHex "aj"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charHex 1x; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_charHex 12b; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

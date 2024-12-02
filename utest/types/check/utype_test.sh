#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_utype" "shellNS_types_check_utype_test"

shellNS_types_check_utype_test() {
  utestTestResult=$(shellNS_types_check_utype "int"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_utype "int|float"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_utype "?int|float"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_utype "? int | float"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_utype "?int|float|notexist"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}
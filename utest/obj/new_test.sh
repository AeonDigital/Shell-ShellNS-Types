#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_new" "shellNS_types_new_test"

shellNS_types_new_test() {
  utestTestResult=$(shellNS_types_new "testObj" "invalidType" "32"; echo "$?")
  utestTestExpected="10"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_new "testObj" "int" "invalidType"; echo "$?")
  utestTestExpected="11"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_new "testObj" "int" "32"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal





  shellNS_types_new "testObj" "int" "32"
  utestTestResult=$(shellNS_types_check_assoc "testObj"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult="${testObj["type"]}"
  utestTestExpected="int"

  shellNS_utest_assert_equal


  utestTestResult="${testObj["value"]}"
  utestTestExpected="32"

  shellNS_utest_assert_equal





  shellNS_types_set "testObj" "64"
  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult="${testObj["value"]}"
  utestTestExpected="64"

  shellNS_utest_assert_equal
}
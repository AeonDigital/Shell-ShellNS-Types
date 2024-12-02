#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_get" "shellNS_types_get_test"

shellNS_types_get_test() {
  shellNS_types_new "testObj" "int" "32"
  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult="${testObj["value"]}"
  utestTestExpected="32"

  shellNS_utest_assert_equal


  shellNS_types_set "testObj" "64"
  utestTestResult=$(shellNS_types_get "testObj")
  utestTestExpected="${testObj["value"]}"

  shellNS_utest_assert_equal





  shellNS_types_get "notInitializedInstance"
  utestTestResult="$?"
  utestTestExpected="12"

  shellNS_utest_assert_equal



  unset testObj["type"]
  shellNS_types_get "testObj"
  utestTestResult="$?"
  utestTestExpected="13"

  shellNS_utest_assert_equal
}
#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_utypes_to_array" "shellNS_utypes_to_array_test"

shellNS_utypes_to_array_test() {

  local -a arrayUnionTypes=()
  shellNS_utypes_to_array " ?int|invalidType" "arrayUnionTypes"

  utestTestResult="$?"
  utestTestExpected="1"

  shellNS_utest_assert_equal



  local -a arrayUnionTypes=()
  shellNS_utypes_to_array " ?int  |  float  |  date  |  string " "arrayUnionTypes"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal



  utestTestResult="${#arrayUnionTypes[@]}"
  utestTestExpected="4"

  shellNS_utest_assert_equal


  utestTestResult="${arrayUnionTypes[0]}"
  utestTestExpected="int"

  shellNS_utest_assert_equal


  utestTestResult="${arrayUnionTypes[1]}"
  utestTestExpected="float"

  shellNS_utest_assert_equal


  utestTestResult="${arrayUnionTypes[2]}"
  utestTestExpected="date"

  shellNS_utest_assert_equal


  utestTestResult="${arrayUnionTypes[3]}"
  utestTestExpected="string"

  shellNS_utest_assert_equal
}
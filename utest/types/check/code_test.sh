#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_code" "shellNS_types_check_code_test"

shellNS_types_check_code_test() {
  utestTestResult=$(shellNS_types_check_code "\n"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_code "\t"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_code "\r"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_check_code "\e[1;34m"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  local codeNL=$'\n'
  utestTestResult=$(shellNS_types_check_code ${codeNL}; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal


  local codeColor=$(echo -e "\e[1;34m")
  utestTestResult=$(shellNS_types_check_code "${codeColor}"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

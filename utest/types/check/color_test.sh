#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_color" "shellNS_types_check_color_test"

shellNS_types_check_color_test() {
  utestTestResult=$(shellNS_types_check_color "\e[1;34m"; echo "$?")
  utestTestExpected="0"

  shellNS_utest_assert_equal


  local codeColor=$(echo -e "\e[1;34m")
  utestTestResult=$(shellNS_types_check_color "${codeColor}"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal
}

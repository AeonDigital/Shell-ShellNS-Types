#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_convert_time_to_int" "shellNS_types_convert_time_to_int_test"

shellNS_types_convert_time_to_int_test() {
  utestTestResult=$(shellNS_types_convert_time_to_int "notConversible"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal



  utestTestResult=$(shellNS_types_convert_time_to_int "12:10:10")
  utestTestExpected="43810"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_convert_time_to_int "12:10")
  utestTestExpected="43800"

  shellNS_utest_assert_equal
}
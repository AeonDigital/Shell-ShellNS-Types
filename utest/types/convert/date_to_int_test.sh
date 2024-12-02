#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_convert_date_to_int" "shellNS_types_convert_date_to_int_test"

shellNS_types_convert_date_to_int_test() {
  utestTestResult=$(shellNS_types_convert_date_to_int "notConversible"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal



  utestTestResult=$(shellNS_types_convert_date_to_int "2024-04")
  utestTestExpected="1711940400"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_convert_date_to_int "2024-04-02")
  utestTestExpected="1712026800"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_convert_date_to_int "2024-04-02 12:40:45")
  utestTestExpected="1712072445"

  shellNS_utest_assert_equal


  utestTestResult=$(shellNS_types_convert_date_to_int "2024-04-02T12:40:45Z")
  utestTestExpected="1712061645"

  shellNS_utest_assert_equal
}
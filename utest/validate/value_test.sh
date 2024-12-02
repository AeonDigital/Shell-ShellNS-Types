#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_validate_value" "shellNS_validate_value_test"

shellNS_validate_value_test() {
  shellNS_validate_value_test_errors_by_type
  shellNS_validate_value_test_success_nullable
  shellNS_validate_value_test_error_invalidValue
  shellNS_validate_value_test_check_array_list
  shellNS_validate_value_test_check_assoc_list
  shellNS_validate_value_test_check_string_file_dir_min_max
  shellNS_validate_value_test_check_date_min_max
  shellNS_validate_value_test_check_time_min_max
  shellNS_validate_value_test_check_array_min_max
}

shellNS_validate_value_test_errors_by_type() {
  shellNS_validate_value "invalidType"

  utestTestResult="$?"
  utestTestExpected="10"

  shellNS_utest_assert_equal



  shellNS_validate_value "int" "" "notArray"

  utestTestResult="$?"
  utestTestExpected="11"

  shellNS_utest_assert_equal



  local -A assocTmpEmptyAssoc
  shellNS_validate_value "int" "" "assocTmpEmptyAssoc"

  utestTestResult="$?"
  utestTestExpected="12"

  shellNS_utest_assert_equal



  shellNS_validate_value "int" "" "" "minNotComparable"

  utestTestResult="$?"
  utestTestExpected="13"

  shellNS_utest_assert_equal



  shellNS_validate_value "int" "" "" "3" "maxNotComparable"

  utestTestResult="$?"
  utestTestExpected="14"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_success_nullable() {
  shellNS_validate_value "?int" ""

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_error_invalidValue() {
  shellNS_validate_value "int" "invalidValue"

  utestTestResult="$?"
  utestTestExpected="20"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_array_list() {
  local -a arrayTmpValues=(1 2 3 4 5 6 7 8 9 10)


  shellNS_validate_value "int" "11" "arrayTmpValues"

  utestTestResult="$?"
  utestTestExpected="21"

  shellNS_utest_assert_equal


  shellNS_validate_value "int" "2" "arrayTmpValues" "3" "7"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal


  shellNS_validate_value "int" "8" "arrayTmpValues" "3" "7"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal


  shellNS_validate_value "int" "5" "arrayTmpValues" "3" "7"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_assoc_list() {
  local -A assocTmpValues
  assocTmpValues["1"]="one"
  assocTmpValues["2"]="two"
  assocTmpValues["3"]="three"
  assocTmpValues["4"]="four"
  assocTmpValues["5"]="five"
  assocTmpValues["6"]="six"
  assocTmpValues["7"]="seven"
  assocTmpValues["8"]="eight"
  assocTmpValues["9"]="nine"
  assocTmpValues["10"]="ten"

  shellNS_validate_value "int" "11" "assocTmpValues"

  utestTestResult="$?"
  utestTestExpected="21"

  shellNS_utest_assert_equal


  shellNS_validate_value "int" "2" "assocTmpValues" "3" "7"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal


  shellNS_validate_value "int" "8" "assocTmpValues" "3" "7"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal


  shellNS_validate_value "int" "5" "assocTmpValues" "3" "7"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_string_min_max() {
  shellNS_validate_value "string" "err" "" "5" "10"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal


  shellNS_validate_value "string" "big word err" "" "5" "10"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal


  shellNS_validate_value "string" "assert ok" "" "5" "10"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_string_file_dir_min_max() {
  shellNS_validate_value "string" "err" "" "5" "10"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal


  shellNS_validate_value "string" "big word err" "" "5" "10"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal


  shellNS_validate_value "string" "assert ok" "" "5" "10"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_date_min_max() {
  shellNS_validate_value "date" "2024-10-09" "" "2024-10-10" "2024-10-20"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal


  shellNS_validate_value "date" "2024-10-21" "" "2024-10-10" "2024-10-20"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal


  shellNS_validate_value "date" "2024-10-10" "" "2024-10-10" "2024-10-20"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_time_min_max() {
  shellNS_validate_value "hour" "10:30:09" "" "10:30:10" "10:30:20"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal


  shellNS_validate_value "hour" "10:30:21" "" "10:30:10" "10:30:20"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal


  shellNS_validate_value "hour" "10:30:20" "" "10:30:10" "10:30:20"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}

shellNS_validate_value_test_check_array_min_max() {
  local -a arrayTmpValues=()

  arrayTmpValues=(1 2)
  shellNS_validate_value "array" "arrayTmpValues" "" "3" "7"

  utestTestResult="$?"
  utestTestExpected="22"

  shellNS_utest_assert_equal



  arrayTmpValues=(1 2 3 4 5 6 7 8)
  shellNS_validate_value "array" "arrayTmpValues" "" "3" "7"

  utestTestResult="$?"
  utestTestExpected="23"

  shellNS_utest_assert_equal



  arrayTmpValues=(1 2 3 4 5)
  shellNS_validate_value "array" "arrayTmpValues" "" "3" "7"

  utestTestResult="$?"
  utestTestExpected="0"

  shellNS_utest_assert_equal
}
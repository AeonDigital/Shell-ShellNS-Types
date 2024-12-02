#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_any_comparable" "shellNS_types_check_any_comparable_test"

shellNS_types_check_any_comparable_test() {
  utestTestResult=$(shellNS_types_check_any_comparable "notComparable"; echo "$?")
  utestTestExpected="1"

  shellNS_utest_assert_equal



  local -A assocTestOK
  assocTestOK["int"]="100"
  assocTestOK["float"]="100.1"
  assocTestOK["dateTimeLocal"]="2024-02-29T12:30:30Z"
  assocTestOK["dateTime"]="2024-02-29 00:00:00"
  assocTestOK["date"]="2024-02-29"
  assocTestOK["month"]="2024-02"
  assocTestOK["hour"]="23:59:59"
  assocTestOK["minute"]="23:59"

  local k=""
  local v=""
  for k in "${!assocTestOK[@]}"; do
    v="${assocTestOK[$k]}"
    utestTestResult=$(shellNS_types_check_any_comparable "${v}"; echo "$?")
    utestTestExpected="0"

    shellNS_utest_assert_equal
  done
}
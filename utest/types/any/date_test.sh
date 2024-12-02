#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_any_date" "shellNS_types_check_any_date_test"

shellNS_types_check_any_date_test() {
  local k=""
  local v=""


  local -A assocTestFalse
  assocTestFalse["string"]="notDate"
  assocTestFalse["int"]="100"
  assocTestFalse["float"]="100.1"
  assocTestFalse["hour"]="23:59:59"
  assocTestFalse["minute"]="23:59"

  for k in "${!assocTestFalse[@]}"; do
    v="${assocTestFalse[$k]}"
    utestTestResult=$(shellNS_types_check_any_date "${v}"; echo "$?")
    utestTestExpected="1"

    shellNS_utest_assert_equal
  done



  local -A assocTestOK
  assocTestOK["dateTimeLocal"]="2024-02-29T12:30:30Z"
  assocTestOK["dateTime"]="2024-02-29 00:00:00"
  assocTestOK["date"]="2024-02-29"
  assocTestOK["month"]="2024-02"

  for k in "${!assocTestOK[@]}"; do
    v="${assocTestOK[$k]}"
    utestTestResult=$(shellNS_types_check_any_date "${v}"; echo "$?")
    utestTestExpected="0"

    shellNS_utest_assert_equal
  done
}
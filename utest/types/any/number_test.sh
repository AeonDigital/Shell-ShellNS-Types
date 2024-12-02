#!/usr/bin/env bash

shellNS_utest_register "ShellNS-Types" "shellNS_types_check_any_number" "shellNS_types_check_any_number_test"

shellNS_types_check_any_number_test() {
  local k=""
  local v=""


  local -A assocTestFalse
  assocTestFalse["string"]="notNumber"
  assocTestFalse["dateTimeLocal"]="2024-02-29T12:30:30Z"
  assocTestFalse["dateTime"]="2024-02-29 00:00:00"
  assocTestFalse["date"]="2024-02-29"
  assocTestFalse["month"]="2024-02"
  assocTestFalse["hour"]="23:59:59"
  assocTestFalse["minute"]="23:59"

  for k in "${!assocTestFalse[@]}"; do
    v="${assocTestFalse[$k]}"
    utestTestResult=$(shellNS_types_check_any_number "${v}"; echo "$?")
    utestTestExpected="1"

    shellNS_utest_assert_equal
  done



  local -A assocTestOK
  assocTestOK["int"]="100"
  assocTestOK["float"]="100.1"

  for k in "${!assocTestOK[@]}"; do
    v="${assocTestOK[$k]}"
    utestTestResult=$(shellNS_types_check_any_number "${v}"; echo "$?")
    utestTestExpected="0"

    shellNS_utest_assert_equal
  done
}
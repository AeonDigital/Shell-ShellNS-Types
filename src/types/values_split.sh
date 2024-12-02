#!/usr/bin/env bash

#
# Converts a string of values into an array containing them.
#
# @param type $1
# Definition of the expanded type.
#
# @param string $2
# Original string with multiple values.
#
# @param array $3
# Name of the array that will receive the values.
#
# @return string+array
shellNS_types_values_split() {
  local strType="${1}"
  local strValues="${2}"

  local strSeparator=$(shellNS_string_trim_raw "${strType}")
  strSeparator="${strType#*\[}"
  strSeparator="${strSeparator:0: -1}"

  shellNS_string_split "${3}" "${strSeparator}" "${strValues}" "1" "1"
}
#!/usr/bin/env bash

#
# Converts the passed union type to an array.
#
# This function does not validate the types entered.
#
# @param utype $1
# Union type to be converted.
#
# @param array $2
# Name of the array that will receive the types that
# make up the union type.
#
# @return status+array
shellNS_utypes_to_array() {
  local strUnionType="${1}"
  strUnionType="${strUnionType//\?/}"
  strUnionType="${strUnionType// /}"


  local -n arrayTmpUnionTypes="${2}"
  arrayTmpUnionTypes=()
  IFS="|" read -r -a arrayTmpUnionTypes <<< "${strUnionType}"
  unset IFS


  local strType=""
  for strType in "${arrayTmpUnionTypes[@]}"; do
    shellNS_types_check_type "${strType}"
    if [ "$?" != "0" ]; then
     return 1
    fi
  done
  return 0
}
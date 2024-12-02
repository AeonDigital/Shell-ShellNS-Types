#!/usr/bin/env bash

#
# Checks if the passed value is a representative of any number type.
#
# It includes all types below:  
# **numerics**
# - int
# - float
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_any_number() {
  local strValue="${1}"
  local -a arrayCheckTypes=("int" "float")
  local strValidateCmd=""
  local it=""

  for it in "${arrayCheckTypes[@]}"; do
    strValidateCmd="shellNS_types_check_${it}"

    if [ $("${strValidateCmd}" "${strValue}"; echo -ne "$?") == "0" ]; then
      return 0
    fi
  done
  return 1
}
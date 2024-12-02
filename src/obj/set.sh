#!/usr/bin/env bash

#
# Resets the current value of the indicated instance.
#
# @param assoc $1
# Name of the associative array that represent the target instance.
#
# @param mixed $2
# Value to set.
#
# @return status
# See the description below for possible status codes.
#
# _,**Possible status codes**,_
#
# 11 : Invalid value  
# 12 : Invalid instance  
# 13 : Corrupted instance
#
# 0  : Success
shellNS_types_set() {
  if ! [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -A"* ]]; then
    return 12
  fi

  local -n _assoc="${1}"
  if [ "${_assoc["type"]}" == "" ]; then
    return 13
  fi

  local strType="${_assoc["type"]}"
  local strValue="${2}"

  local strCheckFunctionName="shellNS_types_check_${_assoc["type"]}"
  local isValid=$(${strCheckFunctionName} "${strValue}" && echo "1" || echo "0")

  if [ "${isValid}" == "0" ]; then
    return 11
  fi

  _assoc["value"]="${strValue}"
  return 0
}
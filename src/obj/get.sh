#!/usr/bin/env bash

#
# Returns the current value of the indicated instance.
#
# @param assoc $1
# Name of the associative array that represent the target instance.
#
# @return status
# See the description below for possible status codes.
#
# _,**Possible status codes**,_
#
# 12 : Invalid instance  
# 13 : Corrupted instance
#
# 0  : Success
shellNS_types_get() {
  if ! [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -A"* ]]; then
    return 12
  fi

  local -n _assoc="${1}"
  if [ "${_assoc["type"]}" == "" ]; then
    return 13
  fi

  echo "${_assoc["value"]}"
  return 0
}
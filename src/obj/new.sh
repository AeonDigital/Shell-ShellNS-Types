#!/usr/bin/env bash

#
# Starts an associative array as a delegate to an object of the defined type.
#
# @param assoc $1
# Name of the associative array that will represent the instantiated type.
#
# @param string $2
# Type of the instance.
#
# @param mixed $3
# Initial value.  
# Must be a valid value for the defined type.
#
# @return status
# See the description below for possible status codes.
#
# _,**Possible status codes**,_
#
# 10 : Invalid type  
# 11 : Invalid value
#
# 0  : Success
#
# The following keys will be generated in the associative array:
# - [type]  Name of the type.
# - [value] The current value of instance.
shellNS_types_new() {
  local strAssoc="${1}"
  local strType="${2}"
  local strValue="${3}"

  local isTypeAvailable="0"
  local it=""
  for it in "${SHELLNS_TYPES_AVAILABLE[@]}"; do
    if [ "${it}" == "${strType}" ]; then
      isTypeAvailable="1"
      break
    fi
  done

  if [ "${isTypeAvailable}" == "0" ]; then
    return 10
  fi

  local strCheckFunctionName="shellNS_types_check_${strType}"
  local isValid=$(${strCheckFunctionName} "${strValue}" && echo "1" || echo "0")
  if [ "${isValid}" == "0" ]; then
    return 11
  fi

  eval "unset ${strAssoc}; declare -gA ${strAssoc};"
  local -n _assoc="${strAssoc}"

  _assoc["type"]="${strType}"
  _assoc["value"]="${strValue}"
  return 0
}
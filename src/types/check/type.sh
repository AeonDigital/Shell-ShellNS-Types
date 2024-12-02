#!/usr/bin/env bash

#
# Checks if the passed value is a recognized **type**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_type() {
  local strType="${1}"
  strType="${strType//\?/}"
  strType="${strType// /}"
  strType="${strType%%[*}"

  if [ "${strType}" == "" ] || [ "${#SHELLNS_TYPES_AVAILABLE[@]}" == "0" ]; then
    return 1
  fi

  if [[ " ${SHELLNS_TYPES_AVAILABLE[@]} " == *\ ${strType}\ * ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("type")
#!/usr/bin/env bash

#
# Checks if the passed value is a recognized **Union type**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_utype() {
  local -a arrayUnionTypes=()
  shellNS_utypes_to_array "${1}" "arrayUnionTypes"

  local strType=""
  for strType in "${arrayUnionTypes[@]}"; do
    if [ $(shellNS_types_check_type "${strType}"; echo -ne "$?") != "0" ]; then
      return 1
    fi
  done

  return 0
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("utype")
#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **bool**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_bool() {
  if [ "${1}" == "0" ] || [ "${1}" == "1" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("bool")
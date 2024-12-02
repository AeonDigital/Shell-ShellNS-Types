#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **assoc**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_assoc() {
  if [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -A"* ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("assoc")
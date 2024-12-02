#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **array**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_array() {
  if [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -a"* ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("array")
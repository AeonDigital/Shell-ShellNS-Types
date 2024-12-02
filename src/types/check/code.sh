#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **code**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_code() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_CODE ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("code")
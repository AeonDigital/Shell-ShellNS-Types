#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **minute**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_minute() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_MINUTE ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("minute")
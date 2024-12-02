#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **dateTime**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_dateTime() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_DATETIME ]] && [ $(date -d "${1}" > /dev/null 2>&1; echo "$?") == "0" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("dateTime")
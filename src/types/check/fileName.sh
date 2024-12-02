#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **fileName**.
#
# @param mixed $1
# Value that will be tested.  
# Just the file name, without its path. The file may or may not exist.
#
# @return status
shellNS_types_check_fileName() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_FILENAME ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("fileName")
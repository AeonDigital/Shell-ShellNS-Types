#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **dirName**.
#
# @param mixed $1
# Value that will be tested.  
# Just the directory name, without its path. The dir may or may not exist.
#
# @return status
shellNS_types_check_dirName() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_DIRNAME ]]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("dirName")
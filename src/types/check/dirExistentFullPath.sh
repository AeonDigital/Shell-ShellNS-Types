#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type
# **dirExistentFullPath**.
#
# @param mixed $1
# Value that will be tested.  
# Full path to the target directory. The directory must exist.
#
# @return status
shellNS_types_check_dirExistentFullPath() {
  if [ -d "${1}" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("dirExistentFullPath")
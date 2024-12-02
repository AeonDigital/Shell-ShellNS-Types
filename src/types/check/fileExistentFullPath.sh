#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type
# **fileExistentFullPath**.
#
# @param mixed $1
# Value that will be tested.  
# Full path to the target file. The file must exist.
#
# @param mixed $2
# Auxiliary.
#
# @return status
shellNS_types_check_fileExistentFullPath() {
  if [ -f "${1}" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("fileExistentFullPath")
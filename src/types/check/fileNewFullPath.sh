#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **fileNewFullPath**.
#
# @param mixed $1
# Value that will be tested.  
# Full path to the new file. The file cannot exist.
#
# @return status
shellNS_types_check_fileNewFullPath() {
  if [ ! -f "${1}" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("fileNewFullPath")
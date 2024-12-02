#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **dirRelativePath**.
#
# @param mixed $1
# Value that will be tested.  
# Relative path to the target directory. The directory may or may not exist.
#
# @return status
shellNS_types_check_dirRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("dirRelativePath")
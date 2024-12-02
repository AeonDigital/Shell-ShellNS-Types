#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type
# **fileNewRelativePath**.
#
# @param mixed $1
# Value that will be tested.  
# Relative path to the new file. The file cannot exist.
#
# @return status
shellNS_types_check_fileNewRelativePath() {
  #
  # OBS:
  # It is not possible to effectively validate the existence of a relative path,
  # so the validation must be complemented in the context of the script.
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("fileNewRelativePath")
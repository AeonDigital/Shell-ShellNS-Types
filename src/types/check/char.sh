#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **char**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_char() {
  #
  # The change of the "LC_CTYPE" below
  # solves multibyte/UTF8 character count by ensuring
  # that each multibyte character is even counted only 1 time.
  local oLC_CTYPE="$LC_CTYPE"
  LC_CTYPE=""
  local strLen="${#1}"
  LC_CTYPE="${oLC_CTYPE}"

  if [ "${strLen}" == "1" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("char")
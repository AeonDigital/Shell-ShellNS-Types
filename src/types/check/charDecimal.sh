#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **charDecimal**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_charDecimal() {
  local intI=""
  local arrParam=(${1// / })

  for (( intI=0; intI<${#arrParam[@]}; intI++ )); do
    if ! [[ "${arrParam[$intI]}" =~ $SHELLNS_TYPES_REGEX_CHARDECIMAL ]]; then
      return 1
    fi
  done

  return 0
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("charDecimal")
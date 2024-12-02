#!/usr/bin/env bash

#
# Checks if the passed value is a representative of type **function**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_function() {
  local strTest="local evalResult=\"0\"; [ \"\$(type -t ${1})\" == \"function\" ] && echo 1"
  local isOk=$(eval "${strTest}")
  if [ "${isOk}" == "1" ]; then
    return 0
  fi
  return 1
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("function")
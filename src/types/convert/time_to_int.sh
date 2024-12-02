#!/usr/bin/env bash

#
# Converts any type of time to an integer value.
#
# @param hour|minute $1
# Time that will be converted.
#
# @return int
shellNS_types_convert_time_to_int() {
  if [ $(shellNS_types_check_any_time "${1}"; echo -ne "$?") == "0" ]; then
    local strTime="${1}"
    if [ "${#strTime}" == "5" ]; then
      strTime+=":00"
    fi
    strTime="1970-01-01T${strTime}Z"

    date -d "${strTime}" +%s
    return 0
  fi
  return 1
}
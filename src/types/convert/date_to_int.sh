#!/usr/bin/env bash

#
# Converts any type of date to an integer value (timestamp).
#
# @param dateTimeLocal|dateTime|date|month $1
# Date that will be converted.
#
# @return int
shellNS_types_convert_date_to_int() {
  if [ $(shellNS_types_check_any_date "${1}"; echo -ne "$?") == "0" ]; then
    local strDate="${1}"
    if [ "${#strDate}" == "7" ]; then
      strDate+="-01"
    fi

    date -d "${strDate}" +%s
    return 0
  fi
  return 1
}
#!/usr/bin/env bash

#
# Checks if the passed value is a representative of any date type.
#
# It includes all types below:  
# **date**
# - dateTimeLocal
# - dateTime
# - date
# - month
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_any_date() {
  local strValue="${1}"
  local -a arrayCheckTypes=("dateTimeLocal" "dateTime" "date" "month")
  local strValidateCmd=""
  local it=""

  for it in "${arrayCheckTypes[@]}"; do
    strValidateCmd="shellNS_types_check_${it}"

    if [ $("${strValidateCmd}" "${strValue}"; echo -ne "$?") == "0" ]; then
      return 0
    fi
  done
  return 1
}
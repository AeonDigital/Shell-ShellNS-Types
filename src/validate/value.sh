#!/usr/bin/env bash

#
# Verifies that the value matches the indicated type and validation rules.
#
# @param type $1
# Expected type.
#
# @param mixed $2
# Value to be tested.
#
# @param ?array|assoc $3
# Name of the array|assoc that contains the list of values accepted as valid.
#
# If the name of an associative array is entered, it uses only the keys as
# acceptable values.
#
# @param ?int $4
# Lowest allowed value or minimum number of characters.
#
# @param ?int $5
# Highest allowed value or maximum number of characters.
#
# @return status
# See the description below for possible status codes.
#
# _,**Possible status codes**,_
#
# _,Validate config errors,_
# 10 : Unrecognized type  
# 11 : List name does not match an 'array' or 'assoc' object  
# 12 : List name points to an empty 'array' or 'assoc' object  
# 13 : Invalid valur for 'min'  
# 14 : Invalid valur for 'max'
#
# _,Invalid value,_
# 20 : Value and type do not match  
# 21 : Given value is not in list  
# 22 : Value is less than the minimum allowed  
# 23 : Value is greater than the maximum allowed
#
# 0  : Success
shellNS_validate_value() {
  local strValidateType="${1}"
  local strValidateValue="${2}"
  local strValidateList="${3}"
  local intValidateMin="${4}"
  local intValidateMax="${5}"

  local -n arrayAllowedValues
  local strListType=""
  local isMatch="0"



  #
  # Step 01
  # Check if configuration parameters are valid


  #
  # If 'type' is valid
  if [ $(shellNS_types_check_type "${strValidateType}"; echo -ne "$?") != "0" ]; then
    return 10
  fi


  #
  # If 'list' exist
  # it must be a valid 'array' or 'assoc' objects with at least 1 element.
  if [ "${strValidateList}" != "" ]; then
    if [ $(shellNS_types_check_any_array "${strValidateList}"; echo -ne "$?") != "0" ]; then
      return 11
    fi

    arrayAllowedValues="${strValidateList}"
    if [ "${#arrayAllowedValues[@]}" == "0" ]; then
      return 12
    fi
  fi


  #
  # If 'min' exist, must be a 'comparable' type
  if [ "${intValidateMin}" != "" ] && [ $(shellNS_types_check_any_comparable "${intValidateMin}"; echo -ne "$?") != "0" ]; then
    return 13
  fi


  #
  # If 'min' exist, must be a 'comparable' type
  if [ "${intValidateMax}" != "" ] && [ $(shellNS_types_check_any_comparable "${intValidateMax}"; echo -ne "$?") != "0" ]; then
    return 14
  fi



  #
  # Step 02
  # Check if value is valid


  #
  # If 'type' is nullable and value is empty
  if [[ "${strValidateType}" == *\?* ]] && [ "${strValidateValue}" == "" ]; then
    return 0
  fi


  #
  # Check if the value and type match
  strValidateType="${strValidateType//\?/}"
  strValidateType="${strValidateType// /}"

  local strValidateCmd="shellNS_types_check_${strValidateType}"
  if [ $("${strValidateCmd}" "${strValidateValue}"; echo -ne "$?") != "0" ]; then
    return 20
  fi


  #
  # If a list of values has been passed...
  if [ "${strValidateList}" != "" ]; then
    strListType="array"
    if [ $(shellNS_types_check_assoc "${strValidateList}"; echo -ne "$?") == "0" ]; then
      strListType="assoc"
    fi


    #
    # Check if the value is among those allowed.
    isMatch="0"
    if [ "${strListType}" == "array" ]; then
      local v=""
      for v in "${arrayAllowedValues[@]}"; do
        if [ "${v}" == "${strValidateValue}" ]; then
          isMatch="1"
          break
        fi
      done
    else
      local k=""
      for k in "${!arrayAllowedValues[@]}"; do
        if [ "${k}" == "${strValidateValue}" ]; then
          isMatch="1"
          break
        fi
      done
    fi

    if [ "${isMatch}" == "0" ]; then
      return 21
    fi
  fi





  #
  # Check minimum and maximum values.
  if [ "${intValidateMin}" != "" ]; then
    local intMinMaxCompareValue=""

    case "${strValidateType}" in
    "int"|"float")
      intMinMaxCompareValue="${strValidateValue}"
      ;;
    "string")
      intMinMaxCompareValue="${#strValidateValue}"
      ;;
    "file|fileFullPath|fileRelativePath|fileExistentFullPath|fileExistentRelativePath|fileNewFullPath|fileNewRelativePath")
      intMinMaxCompareValue="${#strValidateValue}"
      ;;
    "dir|dirFullPath|dirRelativePath|dirExistentFullPath|dirExistentRelativePath|dirNewFullPath|dirNewRelativePath")
      intMinMaxCompareValue="${#strValidateValue}"
      ;;
    "dateTimeLocal"|"dateTime"|"date"|"month")
      intValidateMin=$(shellNS_types_convert_date_to_int "${intValidateMin}")
      intMinMaxCompareValue=$(shellNS_types_convert_date_to_int "${strValidateValue}")
      ;;
    "hour"|"minute")
      intValidateMin=$(shellNS_types_convert_time_to_int "${intValidateMin}")
      intMinMaxCompareValue=$(shellNS_types_convert_time_to_int "${strValidateValue}")
      ;;
    "array"|"assoc")
      local -n tmpArrayOrAssoc="${strValidateValue}"
      intMinMaxCompareValue="${#tmpArrayOrAssoc[@]}"
      ;;
    esac

    if [ "${intMinMaxCompareValue}" -lt "${intValidateMin}" ]; then
      return 22
    fi
  fi


  if [ "${intValidateMax}" != "" ]; then
    local intMinMaxCompareValue=""

    case "${strValidateType}" in
    "int"|"float")
      intMinMaxCompareValue="${strValidateValue}"
      ;;
    "string")
      intMinMaxCompareValue="${#strValidateValue}"
      ;;
    "file|fileFullPath|fileRelativePath|fileExistentFullPath|fileExistentRelativePath|fileNewFullPath|fileNewRelativePath")
      intMinMaxCompareValue="${#strValidateValue}"
      ;;
    "dir|dirFullPath|dirRelativePath|dirExistentFullPath|dirExistentRelativePath|dirNewFullPath|dirNewRelativePath")
      intMinMaxCompareValue="${#strValidateValue}"
      ;;
    "dateTimeLocal"|"dateTime"|"date"|"month")
      intValidateMax=$(shellNS_types_convert_date_to_int "${intValidateMax}")
      intMinMaxCompareValue=$(shellNS_types_convert_date_to_int "${strValidateValue}")
      ;;
    "hour"|"minute")
      intValidateMax=$(shellNS_types_convert_time_to_int "${intValidateMax}")
      intMinMaxCompareValue=$(shellNS_types_convert_time_to_int "${strValidateValue}")
      ;;
    "array"|"assoc")
      local -n tmpArrayOrAssoc="${strValidateValue}"
      intMinMaxCompareValue="${#tmpArrayOrAssoc[@]}"
      ;;
    esac

    if [ "${intMinMaxCompareValue}" -gt "${intValidateMax}" ]; then
      return 23
    fi
  fi

  return 0
}
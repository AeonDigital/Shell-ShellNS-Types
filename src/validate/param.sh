#!/usr/bin/env bash

#
# Validates a parameter according to the configured settings.
# Acccepts union types.
#
# Validation stops at the first accepted test.
# Error messages that may occur are related to the last type tested.
#
# @param ?string $1
# Name of the function.
#
# @param utype $2
# Expected union type.
#
# @param int|string $3
# Argument where the value was passed (name or number).
#
# @param ?array|assoc $4
# Name of the array|assoc that contains the list of values accepted as valid.
#
# @param ?int $5
# Lowest allowed value or minimum number of characters.
#
# @param ?int $6
# Highest allowed value or maximum number of characters.
#
# @param mixed $7
# Value that has been tested in validation.
#
# @param ?string $8
# Error message to use.
#
# @param ?string $9
# Additional description for main message.
#
# @return status+string
# Returns a status code and an error message if one has occurred.
#
# **Possible status codes**
#
# 255 : [ $2, $3 ] Lost parameters
#
# **Validate config errors**
# 10 : Unrecognized type
# 11 : List name does not match an 'array' or 'assoc' object
# 12 : List name points to an empty 'array' or 'assoc' object
# 13 : Invalid valur for 'min'
# 14 : Invalid valur for 'max'
#
# **Invalid value**
# 20 : Value and type do not match
# 21 : Given value is not in list
# 22 : Value is less than the minimum allowed
# 23 : Value is greater than the maximum allowed
#
# 0  : Success
shellNS_validate_param() {
  local -a arrayUTypes=()
  shellNS_utypes_to_array "${2}" "arrayUTypes"

  if [ "$?" != "0" ] || [ "${#arrayUTypes[@]}" == "0" ]; then
    local strPH="{{PH_TYPE}}"
    local strErrMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_TYPE//${strPH}/${2}}"

    shellNS_dialog_set "fail" "${strErrMessage}"
    shellNS_dialog_show
    return 10
  fi


  local strType=""
  local strErrorMessage=""
  local -g intValidateResult=""
  local -g strValidateAcceptType=""
  for strType in "${arrayUTypes[@]}"; do
    shellNS_validate_param_simple_type "${1}" "${strType}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"
    if [ "$?" == "0" ]; then
      return "0"
    fi
  done


  local strPH="{{PH_TYPE}}"
  SHELLNS_TYPES_LAST_VALIDATE_MESSAGE="${SHELLNS_TYPES_LAST_VALIDATE_MESSAGE//${strPH}/${2}}"


  shellNS_dialog_set "fail" "${SHELLNS_TYPES_LAST_VALIDATE_MESSAGE}"
  shellNS_dialog_show
  return "${SHELLNS_TYPES_LAST_VALIDATE_STATUS}"
}






#
# Validates a parameter according to the configured settings.
# Acccepts only simple types.
#
# @param ?string $1
# Name of the function.
#
# @param type $2
# Expected type.
#
# @param int|string $3
# Argument where the value was passed (name or number).
#
# @param ?array|assoc $4
# Name of the array|assoc that contains the list of values accepted as valid.
#
# @param ?int $5
# Lowest allowed value or minimum number of characters.
#
# @param ?int $6
# Highest allowed value or maximum number of characters.
#
# @param mixed $7
# Value that has been tested in validation.
#
# @param ?string $8
# Error message to use.
#
# @param ?string $9
# Additional description for main message.
#
# @return status
# Returns a status code and an error message if one has occurred.
#
# **Possible status codes**
#
# 255 : [ $2, $3 ] Lost parameters
#
# **Validate config errors**
# 10 : Unrecognized type
# 11 : List name does not match an 'array' or 'assoc' object
# 12 : List name points to an empty 'array' or 'assoc' object
# 13 : Invalid valur for 'min'
# 14 : Invalid valur for 'max'
#
# **Invalid value**
# 20 : Value and type do not match
# 21 : Given value is not in list
# 22 : Value is less than the minimum allowed
# 23 : Value is greater than the maximum allowed
#
# 0  : Success
shellNS_validate_param_simple_type() {
  SHELLNS_TYPES_LAST_VALIDATE_STATUS=""
  SHELLNS_TYPES_LAST_VALIDATE_MESSAGE=""


  local strFunctionName=$(shellNS_string_trim "${1}")

  local strParamType=$(shellNS_string_trim "${2}")
  local strParamPosition=$(shellNS_string_trim "${3}")
  local strParamValueList=$(shellNS_string_trim "${4}")
  local strParamValueMin=$(shellNS_string_trim "${5}")
  local strParamValueMax=$(shellNS_string_trim "${6}")

  local strParamValue="${7}"

  local strDialogMessage=$(shellNS_string_trim "${8}")
  local strDialogDescription=$(shellNS_string_trim "${9}")


  if [ "${strParamType}" == "" ] || [ "${strParamPosition}" == "" ]; then
    shellNS_dialog_set "error" "${SHELLNS_TYPES_LBL_ERROR_255_LOST_PARAMETERS}"
    shellNS_dialog_show
    return 255
  fi



  #
  # Assemble the trace information
  local strErrTrace=""
  if [ "${strFunctionName}" != "" ]; then
    strErrTrace+="function: '**${strFunctionName}**'; "
  fi
  if [[ "${strParamPosition}" =~ ^-?[0-9]+$ ]]; then
    strErrTrace+="argPos: '**\${${strParamPosition}}**'; "
  else
    strErrTrace+="argName: '**{${strParamPosition}**'; "
  fi
  strErrTrace="${strErrTrace:0: -2}"



  #
  # Check value against validation rules
  shellNS_validate_value "${strParamType}" "${strParamValue}" "${strParamValueList}" "${strParamValueMin}" "${strParamValueMax}"
  local intResultStatus="$?"
  if [ "${intResultStatus}" == "0" ]; then
    return 0
  fi


  if [ "${strDialogMessage}" == "" ]; then
    local strPH=""

    case "${intResultStatus}" in
      "10")
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_TYPE}"
        ;;

      "11")
        strPH="{{PH_LIST}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_LISTNAME//${strPH}/${strParamValueList}}"
        ;;

      "12")
        strPH="{{PH_LIST}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_EMPTY_LIST//${strPH}/${strParamValueList}}"
        ;;

      "13")
        strPH="{{PH_MIN}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_MIN//${strPH}/${strParamValueMin}}"
        ;;

      "14")
        strPH="{{PH_MAX}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_MAX//${strPH}/${strParamValueMax}}"
        ;;



      "20")
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_TYPE}"
        ;;

      "21")
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_NOT_IN_LIST}"
        ;;

      "22")
        strPH="{{PH_MIN}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_MIN//${strPH}/${strParamValueMin}}"
        ;;

      "23")
        strPH="{{PH_MAX}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_MAX//${strPH}/${strParamValueMax}}"
        ;;
    esac



    if [ "${intResultStatus}" -ge "20" ]; then
      strDialogMessage+="\n"

      strPH="{{PH_TRACE}}"
      strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_TRACE//${strPH}/${strErrTrace}}"
      strDialogMessage+="\n"

      strPH="{{PH_VALUE}}"
      strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_VALUE//${strPH}/${strParamValue}}"


      if [ "${intResultStatus}" == "21" ]; then
        strDialogMessage+="\n"

        local k=""
        local strExpectedValues=""
        local -n allowedValuesList="${strParamValueList}"

        if [[ "$(declare -p "${strParamValueList}" 2> /dev/null)" == "declare -a"* ]]; then
          for k in "${allowedValuesList[@]}"; do
            strExpectedValues+="'**${k}**', "
          done
        else
          for k in "${!allowedValuesList[@]}"; do
            strExpectedValues+="'**${k}**' | "
          done
        fi
      fi
      strExpectedValues="${strExpectedValues:0: -3}"

      strPH="{{PH_EXPECTED}}"
      strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_EXPECTED_VALUES//${strPH}/${strExpectedValues}}"
    fi
  fi


  if [ "${strDialogDescription}" != "" ]; then
    strDialogMessage+="\n${strDialogDescription}"
  fi


  SHELLNS_TYPES_LAST_VALIDATE_STATUS="${intResultStatus}"
  SHELLNS_TYPES_LAST_VALIDATE_MESSAGE="${strDialogMessage}"
  return "${intResultStatus}"
}
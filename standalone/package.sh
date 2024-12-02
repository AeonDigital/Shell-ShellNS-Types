#!/usr/bin/env bash

if [[ "$(declare -p "SHELLNS_STANDALONE_LOAD_STATUS" 2> /dev/null)" != "declare -A"* ]]; then
  declare -gA SHELLNS_STANDALONE_LOAD_STATUS
fi
SHELLNS_STANDALONE_LOAD_STATUS["shellns_types_standalone.sh"]="ready"
unset SHELLNS_STANDALONE_DEPENDENCIES
declare -gA SHELLNS_STANDALONE_DEPENDENCIES
shellNS_standalone_install_set_dependency() {
  local strDownloadFileName="shellns_${2,,}_standalone.sh"
  local strPkgStandaloneURL="https://raw.githubusercontent.com/AeonDigital/${1}/refs/heads/main/standalone/package.sh"
  SHELLNS_STANDALONE_DEPENDENCIES["${strDownloadFileName}"]="${strPkgStandaloneURL}"
}
shellNS_standalone_install_set_dependency "Shell-ShellNS-Dialog" "dialog"
declare -gA SHELLNS_DIALOG_TYPE_COLOR=(
  ["raw"]=""
  ["info"]="\e[1;34m"
  ["warning"]="\e[0;93m"
  ["error"]="\e[1;31m"
  ["question"]="\e[1;35m"
  ["input"]="\e[1;36m"
  ["ok"]="\e[20;49;32m"
  ["fail"]="\e[20;49;31m"
)
declare -gA SHELLNS_DIALOG_TYPE_PREFIX=(
  ["raw"]=" - "
  ["info"]="inf"
  ["warning"]="war"
  ["error"]="err"
  ["question"]=" ? "
  ["input"]=" < "
  ["ok"]=" v "
  ["fail"]=" x "
)
declare -g SHELLNS_DIALOG_PROMPT_INPUT=""
shellNS_standalone_install_dialog() {
  local strDialogType="${1}"
  local strDialogMessage="${2}"
  local boolDialogWithPrompt="${3}"
  local codeColorPrefix="${SHELLNS_DIALOG_TYPE_COLOR["${strDialogType}"]}"
  local strMessagePrefix="${SHELLNS_DIALOG_TYPE_PREFIX[${strDialogType}]}"
  if [ "${strDialogMessage}" != "" ] && [ "${codeColorPrefix}" != "" ] && [ "${strMessagePrefix}" != "" ]; then
    local strIndent="        "
    local strPromptPrefix="      > "
    local codeColorNone="\e[0m"
    local codeColorText="\e[0;49m"
    local codeColorHighlight="\e[1;49m"
    local tmpCount="0"
    while [[ "${strDialogMessage}" =~ "**" ]]; do
      ((tmpCount++))
      if (( tmpCount % 2 != 0 )); then
        strDialogMessage="${strDialogMessage/\*\*/${codeColorHighlight}}"
      else
        strDialogMessage="${strDialogMessage/\*\*/${codeColorNone}}"
      fi
    done
    local codeNL=$'\n'
    strDialogMessage=$(echo -ne "${strDialogMessage}")
    strDialogMessage="${strDialogMessage//${codeNL}/${codeNL}${strIndent}}"
    local strShowMessage=""
    strShowMessage+="[ ${codeColorPrefix}${strMessagePrefix}${codeColorNone} ] "
    strShowMessage+="${codeColorText}${strDialogMessage}${codeColorNone}\n"
    echo -ne "${strShowMessage}"
    if [ "${boolDialogWithPrompt}" == "1" ]; then
      SHELLNS_DIALOG_PROMPT_INPUT=""
      read -r -p "${strPromptPrefix}" SHELLNS_DIALOG_PROMPT_INPUT
    fi
  fi
  return 0
}
shellNS_standalone_install_dependencies() {
  if [[ "$(declare -p "SHELLNS_STANDALONE_DEPENDENCIES" 2> /dev/null)" != "declare -A"* ]]; then
    return 0
  fi
  if [ "${#SHELLNS_STANDALONE_DEPENDENCIES[@]}" == "0" ]; then
    return 0
  fi
  local pkgFileName=""
  local pkgSourceURL=""
  local pgkLoadStatus=""
  for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
    pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
    if [ "${pgkLoadStatus}" == "" ]; then pgkLoadStatus="0"; fi
    if [ "${pgkLoadStatus}" == "ready" ] || [ "${pgkLoadStatus}" -ge "1" ]; then
      continue
    fi
    if [ ! -f "${pkgFileName}" ]; then
      pkgSourceURL="${SHELLNS_STANDALONE_DEPENDENCIES[${pkgFileName}]}"
      curl -o "${pkgFileName}" "${pkgSourceURL}"
      if [ ! -f "${pkgFileName}" ]; then
        local strMsg=""
        strMsg+="An error occurred while downloading a dependency.\n"
        strMsg+="URL: **${pkgSourceURL}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
    fi
    chmod +x "${pkgFileName}"
    if [ "$?" != "0" ]; then
      local strMsg=""
      strMsg+="Could not give execute permission to script:\n"
      strMsg+="FILE: **${pkgFileName}**\n\n"
      strMsg+="This execution was aborted."
      shellNS_standalone_install_dialog "error" "${strMsg}"
      return 1
    fi
    SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="1"
  done
  if [ "${1}" == "1" ]; then
    for pkgFileName in "${!SHELLNS_STANDALONE_DEPENDENCIES[@]}"; do
      pgkLoadStatus="${SHELLNS_STANDALONE_LOAD_STATUS[${pkgFileName}]}"
      if [ "${pgkLoadStatus}" == "ready" ]; then
        continue
      fi
      . "${pkgFileName}"
      if [ "$?" != "0" ]; then
        local strMsg=""
        strMsg+="An unexpected error occurred while load script:\n"
        strMsg+="FILE: **${pkgFileName}**\n\n"
        strMsg+="This execution was aborted."
        shellNS_standalone_install_dialog "error" "${strMsg}"
        return 1
      fi
      SHELLNS_STANDALONE_LOAD_STATUS["${pkgFileName}"]="ready"
    done
  fi
}
shellNS_standalone_install_dependencies "1"
unset shellNS_standalone_install_set_dependency
unset shellNS_standalone_install_dependencies
unset shellNS_standalone_install_dialog
unset SHELLNS_STANDALONE_DEPENDENCIES
unset SHELLNS_TYPES_AVAILABLE
declare -ga SHELLNS_TYPES_AVAILABLE=()
if [ ! "${SHELLNS_TYPES_REGEX_INTEGER:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_INTEGER='^[-]?[0-9]+$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_FLOAT:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_FLOAT='^([-]?[0-9]+)([.][0-9]+)?$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_CHARDECIMAL:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CHARDECIMAL='^[0-9]+$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_CHARHEX:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CHARHEX='^[0-9A-Fa-f]{1,2}$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_CHAROCTAL:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CHAROCTAL='^[0-7]{3}$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_FILESYSTEMPATH:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_FILESYSTEMPATH='^[^/][a-zA-Z0-9._/-]*$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_DIRNAME:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DIRNAME='^[a-zA-Z0-9._-]+$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_FILENAME:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_FILENAME='^[a-zA-Z0-9._-]+$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_DATETIMELOCAL:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DATETIMELOCAL='^[0-9]{4}-((0[0-9]{1})|(1[0-2]{1}))-(([0-2]{1}[0-9]{1})|(3[0-1]{1}))T(([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}Z$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_DATETIME:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DATETIME='^[0-9]{4}-((0[0-9]{1})|(1[0-2]{1}))-(([0-2]{1}[0-9]{1})|(3[0-1]{1})) (([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_DATE:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DATE='^[0-9]{4}-(0[1-9]{1}|1[0-2]{1})-(0[1-9]{1}|1[0-9]{1}|2[0-9]{1}|3[0-1]{1})$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_MONTH:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_MONTH='^[0-9]{4}-(0[1-9]{1}|1[0-2]{1})$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_HOUR:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_HOUR='^(([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_MINUTE:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_MINUTE='^(([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}$'
fi
if [ ! "${SHELLNS_TYPES_REGEX_CODE:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CODE='^\\'
fi
if [ ! "${SHELLNS_TYPES_REGEX_COLOR:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_COLOR='^\\e\[[0-9;]*m$'
fi
SHELLNS_TYPES_LAST_VALIDATE_STATUS=""
SHELLNS_TYPES_LAST_VALIDATE_MESSAGE=""
unset SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST
declare -ga SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST=()
SHELLNS_TYPES_LBL_ERROR_255_LOST_PARAMETERS="Lost parameters; Validations cannot be made."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_TYPE="Invalid type '**{{PH_TYPE}}**'."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_LISTNAME="Invalid list '**{{PH_LIST}}**'; Expected **array** or **assoc**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_EMPTY_LIST="Invalid list '**{{PH_LIST}}**'; Expected non empty **array** or **assoc**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_MIN="Invalid '**min**' value: '**{{PH_MIN}}**'; Expected comparable value."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_MAX="Invalid '**max**' value: '**{{PH_MAX}}**'; Expected comparable value."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_TYPE="Invalid value; Expected type '**{{PH_TYPE}}**'."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_NOT_IN_LIST="Invalid value; Expected a value from the **list**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_MIN="Invalid value; Minimum allowed is **{{PH_MIN}}**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_MAX="Invalid value; Maximum allowed is **{{PH_MAX}}**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_TRACE="in {{PH_TRACE}}"
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_VALUE="given: '**{{PH_VALUE}}**'"
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_EMPTY_VALUE="given: ''"
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_EXPECTED_VALUES="expected: {{PH_EXPECTED}}"
shellNS_utypes_to_array() {
  local strUnionType="${1}"
  strUnionType="${strUnionType//\?/}"
  shellNS_string_split "${2}" "|" "${strUnionType}" "1" "1"
  local -n arrayTmpUnionTypes="${2}"
  local strType=""
  for strType in "${arrayTmpUnionTypes[@]}"; do
    shellNS_types_check_type "${strType}"
    if [ "$?" != "0" ]; then
     return 1
    fi
  done
  return 0
}
shellNS_types_values_split() {
  local strType="${1}"
  local strValues="${2}"
  local strSeparator=$(shellNS_string_trim_raw "${strType}")
  strSeparator="${strType#*\[}"
  strSeparator="${strSeparator:0: -1}"
  shellNS_string_split "${3}" "${strSeparator}" "${strValues}" "1" "1"
}
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
shellNS_types_check_fileFullPath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileFullPath")
shellNS_types_check_regex() {
  return 0
}
SHELLNS_TYPES_AVAILABLE+=("regex")
shellNS_types_check_dirName() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_DIRNAME ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirName")
shellNS_types_check_fileExistentFullPath() {
  if [ -f "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileExistentFullPath")
shellNS_types_check_charHex() {
  local intI=""
  local arrParam=(${1// / })
  for (( intI=0; intI<${#arrParam[@]}; intI++ )); do
    if ! [[ "${arrParam[$intI]}" =~ $SHELLNS_TYPES_REGEX_CHARHEX ]]; then
      return 1
    fi
  done
  return 0
}
SHELLNS_TYPES_AVAILABLE+=("charHex")
shellNS_types_check_color() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_COLOR ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("color")
shellNS_types_check_minute() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_MINUTE ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("minute")
shellNS_types_check_type() {
  local strType="${1}"
  strType="${strType//\?/}"
  strType="${strType// /}"
  strType="${strType%%[*}"
  if [ "${strType}" == "" ] || [ "${#SHELLNS_TYPES_AVAILABLE[@]}" == "0" ]; then
    return 1
  fi
  if [[ " ${SHELLNS_TYPES_AVAILABLE[@]} " == *\ ${strType}\ * ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("type")
shellNS_types_check_string() {
  return 0
}
SHELLNS_TYPES_AVAILABLE+=("string")
shellNS_types_check_array() {
  if [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -a"* ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("array")
shellNS_types_check_dirNewFullPath() {
  if [ ! -d "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirNewFullPath")
shellNS_types_check_char() {
  local oLC_CTYPE="$LC_CTYPE"
  LC_CTYPE=""
  local strLen="${#1}"
  LC_CTYPE="${oLC_CTYPE}"
  if [ "${strLen}" == "1" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("char")
shellNS_types_check_hour() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_HOUR ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("hour")
shellNS_types_check_dirExistentRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirExistentRelativePath")
shellNS_types_check_dirRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirRelativePath")
shellNS_types_check_month() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_MONTH ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("month")
shellNS_types_check_fileExistentRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileExistentRelativePath")
shellNS_types_check_code() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_CODE ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("code")
shellNS_types_check_charOctal() {
  local intI=""
  local arrParam=(${1// / })
  for (( intI=0; intI<${#arrParam[@]}; intI++ )); do
    if ! [[ "${arrParam[$intI]}" =~ $SHELLNS_TYPES_REGEX_CHAROCTAL ]]; then
      return 1
    fi
  done
  return 0
}
SHELLNS_TYPES_AVAILABLE+=("charOctal")
shellNS_types_check_mixed() {
  return 0
}
SHELLNS_TYPES_AVAILABLE+=("mixed")
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
SHELLNS_TYPES_AVAILABLE+=("charDecimal")
shellNS_types_check_dirExistentFullPath() {
  if [ -d "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirExistentFullPath")
shellNS_types_check_dirFullPath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirFullPath")
shellNS_types_check_fileNewRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileNewRelativePath")
shellNS_types_check_dirNewRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dirNewRelativePath")
shellNS_types_check_function() {
  local strTest="local evalResult=\"0\"; [ \"\$(type -t ${1})\" == \"function\" ] && echo 1"
  local isOk=$(eval "${strTest}")
  if [ "${isOk}" == "1" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("function")
shellNS_types_check_any_array() {
  local strValue="${1}"
  local -a arrayCheckTypes=("array" "assoc")
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
shellNS_types_check_any_comparable() {
  local strValue="${1}"
  local -a arrayCheckTypes=("int" "float" "dateTimeLocal" "dateTime" "date" "month" "hour" "minute")
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
shellNS_types_check_any_time() {
  local strValue="${1}"
  local -a arrayCheckTypes=("hour" "minute")
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
shellNS_types_check_any_datetime() {
  local strValue="${1}"
  local -a arrayCheckTypes=("dateTimeLocal" "dateTime" "date" "month" "hour" "minute")
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
shellNS_types_check_any_number() {
  local strValue="${1}"
  local -a arrayCheckTypes=("int" "float")
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
shellNS_types_check_utype() {
  local -a arrayUnionTypes=()
  shellNS_utypes_to_array "${1}" "arrayUnionTypes"
  local strType=""
  for strType in "${arrayUnionTypes[@]}"; do
    if [ $(shellNS_types_check_type "${strType}"; echo -ne "$?") != "0" ]; then
      return 1
    fi
  done
  return 0
}
SHELLNS_TYPES_AVAILABLE+=("utype")
shellNS_types_check_dateTimeLocal() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_DATETIMELOCAL ]] && [ $(date -d "${1}" > /dev/null 2>&1; echo "$?") == "0" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dateTimeLocal")
shellNS_types_check_float() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_FLOAT ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("float")
shellNS_types_check_fileRelativePath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileRelativePath")
shellNS_types_check_fileName() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_FILENAME ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileName")
shellNS_types_check_assoc() {
  if [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -A"* ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("assoc")
shellNS_types_check_date() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_DATE ]] && [ $(date -d "${1}" > /dev/null 2>&1; echo "$?") == "0" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("date")
shellNS_types_check_int() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_INTEGER ]]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("int")
shellNS_types_check_dateTime() {
  if [[ "${1}" =~ $SHELLNS_TYPES_REGEX_DATETIME ]] && [ $(date -d "${1}" > /dev/null 2>&1; echo "$?") == "0" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("dateTime")
shellNS_types_check_bool() {
  if [ "${1}" == "0" ] || [ "${1}" == "1" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("bool")
shellNS_types_check_fileSystemPath() {
  if [ shellNS_types_check_fileSystemPath "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileSystemPath")
shellNS_types_check_fileNewFullPath() {
  if [ ! -f "${1}" ]; then
    return 0
  fi
  return 1
}
SHELLNS_TYPES_AVAILABLE+=("fileNewFullPath")
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
  local strValue=""
  SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST=()
  local strType=""
  local strErrorMessage=""
  local -g intValidateResult=""
  local -g strValidateAcceptType=""
  for strType in "${arrayUTypes[@]}"; do
    if [[ "${strType}" == *\[* ]]; then
      shellNS_types_values_split "${strType}" "${7}" "SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST"
      strType="${strType%%\[*}"
      if [ "${#SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST[@]}" == "1" ] && [ "${SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST[0]}" == '*' ]; then
        SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST=()
        shellNS_array_sort "${4}" "SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST"
        return "0"
      fi
      for strValue in "${SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST[@]}"; do
        shellNS_validate_param_simple_type "${1}" "${strType}" "${3}" "${4}" "${5}" "${6}" "${strValue}" "${8}" "${9}"
        if [ "$?" != "0" ]; then
          break 2
        fi
      done
      return "0"
    else
      shellNS_validate_param_simple_type "${1}" "${strType}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"
      if [ "$?" == "0" ]; then
        return "0"
      fi
    fi
  done
  local strPH="{{PH_TYPE}}"
  SHELLNS_TYPES_LAST_VALIDATE_MESSAGE="${SHELLNS_TYPES_LAST_VALIDATE_MESSAGE//${strPH}/${2}}"
  shellNS_dialog_set "fail" "${SHELLNS_TYPES_LAST_VALIDATE_MESSAGE}"
  shellNS_dialog_show
  return "${SHELLNS_TYPES_LAST_VALIDATE_STATUS}"
}
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
      if [ "${strParamValue}" == "" ]; then
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_EMPTY_VALUE}"
      else
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_VALUE//${strPH}/${strParamValue}}"
      fi
      if [ "${intResultStatus}" == "21" ]; then
        strDialogMessage+="\n"
        local k=""
        local strExpectedValues=""
        local -n allowedValuesList="${strParamValueList}"
        local -a allowedValuesListSorted=()
        shellNS_array_sort "${strParamValueList}" "allowedValuesListSorted"
        local strSep=""
        local intSepLength="0"
        if [[ "$(declare -p "${strParamValueList}" 2> /dev/null)" == "declare -a"* ]]; then
          strSep=", "
          intSepLength="2"
        else
          strSep=" | "
          intSepLength="3"
        fi
        for k in "${allowedValuesListSorted[@]}"; do
          strExpectedValues+="'**${k}**'${strSep}"
        done
        strExpectedValues="${strExpectedValues:0: -${intSepLength}}"
        strPH="{{PH_EXPECTED}}"
        strDialogMessage+="${SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_EXPECTED_VALUES//${strPH}/${strExpectedValues}}"
      fi
    fi
  fi
  if [ "${strDialogDescription}" != "" ]; then
    strDialogMessage+="\n${strDialogDescription}"
  fi
  SHELLNS_TYPES_LAST_VALIDATE_STATUS="${intResultStatus}"
  SHELLNS_TYPES_LAST_VALIDATE_MESSAGE="${strDialogMessage}"
  return "${intResultStatus}"
}
shellNS_validate_value() {
  local strValidateType="${1}"
  local strValidateValue="${2}"
  local strValidateList="${3}"
  local intValidateMin="${4}"
  local intValidateMax="${5}"
  local -n arrayAllowedValues
  local strListType=""
  local isMatch="0"
  if [ $(shellNS_types_check_type "${strValidateType}"; echo -ne "$?") != "0" ]; then
    return 10
  fi
  if [ "${strValidateList}" != "" ]; then
    if [ $(shellNS_types_check_any_array "${strValidateList}"; echo -ne "$?") != "0" ]; then
      return 11
    fi
    arrayAllowedValues="${strValidateList}"
    if [ "${#arrayAllowedValues[@]}" == "0" ]; then
      return 12
    fi
  fi
  if [ "${intValidateMin}" != "" ] && [ $(shellNS_types_check_any_comparable "${intValidateMin}"; echo -ne "$?") != "0" ]; then
    return 13
  fi
  if [ "${intValidateMax}" != "" ] && [ $(shellNS_types_check_any_comparable "${intValidateMax}"; echo -ne "$?") != "0" ]; then
    return 14
  fi
  if [[ "${strValidateType}" == *\?* ]] && [ "${strValidateValue}" == "" ]; then
    return 0
  fi
  strValidateType="${strValidateType//\?/}"
  strValidateType="${strValidateType// /}"
  local strValidateCmd="shellNS_types_check_${strValidateType}"
  if [ $("${strValidateCmd}" "${strValidateValue}"; echo -ne "$?") != "0" ]; then
    return 20
  fi
  if [ "${strValidateList}" != "" ]; then
    strListType="array"
    if [ $(shellNS_types_check_assoc "${strValidateList}"; echo -ne "$?") == "0" ]; then
      strListType="assoc"
    fi
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
shellNS_types_set() {
  if ! [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -A"* ]]; then
    return 12
  fi
  local -n _assoc="${1}"
  if [ "${_assoc["type"]}" == "" ]; then
    return 13
  fi
  local strType="${_assoc["type"]}"
  local strValue="${2}"
  local strCheckFunctionName="shellNS_types_check_${_assoc["type"]}"
  local isValid=$(${strCheckFunctionName} "${strValue}" && echo "1" || echo "0")
  if [ "${isValid}" == "0" ]; then
    return 11
  fi
  _assoc["value"]="${strValue}"
  return 0
}
shellNS_types_get() {
  if ! [[ "$(declare -p "${1}" 2> /dev/null)" == "declare -A"* ]]; then
    return 12
  fi
  local -n _assoc="${1}"
  if [ "${_assoc["type"]}" == "" ]; then
    return 13
  fi
  echo "${_assoc["value"]}"
  return 0
}
shellNS_types_new() {
  local strAssoc="${1}"
  local strType="${2}"
  local strValue="${3}"
  local isTypeAvailable="0"
  local it=""
  for it in "${SHELLNS_TYPES_AVAILABLE[@]}"; do
    if [ "${it}" == "${strType}" ]; then
      isTypeAvailable="1"
      break
    fi
  done
  if [ "${isTypeAvailable}" == "0" ]; then
    return 10
  fi
  local strCheckFunctionName="shellNS_types_check_${strType}"
  local isValid=$(${strCheckFunctionName} "${strValue}" && echo "1" || echo "0")
  if [ "${isValid}" == "0" ]; then
    return 11
  fi
  eval "unset ${strAssoc}; declare -gA ${strAssoc};"
  local -n _assoc="${strAssoc}"
  _assoc["type"]="${strType}"
  _assoc["value"]="${strValue}"
  return 0
}
SHELLNS_TYPES_LBL_ERROR_255_LOST_PARAMETERS="Lost parameters; Validations cannot be made."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_TYPE="Invalid type '**{{PH_TYPE}}**'."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_LISTNAME="Invalid list '**{{PH_LIST}}**'; Expected **array** or **assoc**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_EMPTY_LIST="Invalid list '**{{PH_LIST}}**'; Expected non empty **array** or **assoc**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_MIN="Invalid '**min**' value: '**{{PH_MIN}}**'; Expected comparable value."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_CONFIG_INVALID_MAX="Invalid '**max**' value: '**{{PH_MAX}}**'; Expected comparable value."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_TYPE="Invalid value; Expected type '**{{PH_TYPE}}**'."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_NOT_IN_LIST="Invalid value; Expected a value from the **list**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_MIN="Invalid value; Minimum allowed is **{{PH_MIN}}**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INVALID_VALUE_MAX="Invalid value; Maximum allowed is **{{PH_MAX}}**."
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_TRACE="in {{PH_TRACE}}"
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_VALUE="received: '**{{PH_VALUE}}**'"
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_EXPECTED_VALUES="expected: **{{PH_EXPECTED}}**"
SHELLNS_TMP_PATH_TO_DIR_MANUALS="$(tmpPath=$(dirname "${BASH_SOURCE[0]}"); realpath "${tmpPath}/src-manuals/${SHELLNS_CONFIG_INTERFACE_LOCALE}")"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_get"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/obj/get.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_new"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/obj/new.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_set"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/obj/set.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_any_array"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/any/array.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_any_comparable"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/any/comparable.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_any_date"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/any/date.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_any_datetime"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/any/datetime.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_any_number"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/any/number.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_any_time"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/any/time.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_array"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/array.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_assoc"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/assoc.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_bool"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/bool.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_char"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/char.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_charDecimal"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/charDecimal.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_charHex"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/charHex.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_charOctal"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/charOctal.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_code"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/code.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_color"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/color.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_date"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/date.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dateTime"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dateTime.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dateTimeLocal"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dateTimeLocal.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirExistentFullPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirExistentFullPath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirExistentRelativePath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirExistentRelativePath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirFullPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirFullPath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirName"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirName.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirNewFullPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirNewFullPath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirNewRelativePath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirNewRelativePath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_dirRelativePath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/dirRelativePath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileExistentFullPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileExistentFullPath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileExistentRelativePath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileExistentRelativePath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileFullPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileFullPath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileName"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileName.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileNewFullPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileNewFullPath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileNewRelativePath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileNewRelativePath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileRelativePath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/fileRelativePath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_fileSystemPath"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/filesystempath.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_float"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/float.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_function"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/function.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_hour"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/hour.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_int"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/int.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_minute"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/minute.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_mixed"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/mixed.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_month"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/month.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_regex"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/regex.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_string"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/string.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_type"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/type.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_check_utype"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/check/utype.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_convert_date_to_int"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/convert/date_to_int.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_convert_time_to_int"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/convert/time_to_int.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_types_values_split"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/types/values_split.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_utypes_to_array"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/utypes/to_array.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_validate_param"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/validate/param.man"
SHELLNS_MAPP_FUNCTION_TO_MANUAL["shellNS_validate_value"]="${SHELLNS_TMP_PATH_TO_DIR_MANUALS}/validate/value.man"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["obj.get"]="shellNS_types_get"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["obj.new"]="shellNS_types_new"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["obj.set"]="shellNS_types_set"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.any.array"]="shellNS_types_check_any_array"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.any.comparable"]="shellNS_types_check_any_comparable"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.any.date"]="shellNS_types_check_any_date"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.any.datetime"]="shellNS_types_check_any_datetime"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.any.number"]="shellNS_types_check_any_number"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.any.time"]="shellNS_types_check_any_time"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.array"]="shellNS_types_check_array"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.assoc"]="shellNS_types_check_assoc"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.bool"]="shellNS_types_check_bool"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.char"]="shellNS_types_check_char"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.charDecimal"]="shellNS_types_check_charDecimal"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.charHex"]="shellNS_types_check_charHex"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.charOctal"]="shellNS_types_check_charOctal"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.code"]="shellNS_types_check_code"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.color"]="shellNS_types_check_color"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.date"]="shellNS_types_check_date"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dateTime"]="shellNS_types_check_dateTime"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dateTimeLocal"]="shellNS_types_check_dateTimeLocal"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirExistentFullPath"]="shellNS_types_check_dirExistentFullPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirExistentRelativePath"]="shellNS_types_check_dirExistentRelativePath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirFullPath"]="shellNS_types_check_dirFullPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirName"]="shellNS_types_check_dirName"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirNewFullPath"]="shellNS_types_check_dirNewFullPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirNewRelativePath"]="shellNS_types_check_dirNewRelativePath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.dirRelativePath"]="shellNS_types_check_dirRelativePath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileExistentFullPath"]="shellNS_types_check_fileExistentFullPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileExistentRelativePath"]="shellNS_types_check_fileExistentRelativePath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileFullPath"]="shellNS_types_check_fileFullPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileName"]="shellNS_types_check_fileName"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileNewFullPath"]="shellNS_types_check_fileNewFullPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileNewRelativePath"]="shellNS_types_check_fileNewRelativePath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.fileRelativePath"]="shellNS_types_check_fileRelativePath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.filesystempath"]="shellNS_types_check_fileSystemPath"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.float"]="shellNS_types_check_float"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.function"]="shellNS_types_check_function"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.hour"]="shellNS_types_check_hour"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.int"]="shellNS_types_check_int"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.minute"]="shellNS_types_check_minute"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.mixed"]="shellNS_types_check_mixed"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.month"]="shellNS_types_check_month"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.regex"]="shellNS_types_check_regex"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.string"]="shellNS_types_check_string"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.type"]="shellNS_types_check_type"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.check.utype"]="shellNS_types_check_utype"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.convert.date.to.int"]="shellNS_types_convert_date_to_int"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.convert.time.to.int"]="shellNS_types_convert_time_to_int"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["types.values.split"]="shellNS_types_values_split"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["utypes.to.array"]="shellNS_utypes_to_array"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["validate.param"]="shellNS_validate_param"
SHELLNS_MAPP_NAMESPACE_TO_FUNCTION["validate.value"]="shellNS_validate_value"
unset SHELLNS_TMP_PATH_TO_DIR_MANUALS

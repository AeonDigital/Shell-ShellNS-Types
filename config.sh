#!/usr/bin/env bash

#
# Package Config


#
# Array that stores all currently defined types.
unset SHELLNS_TYPES_AVAILABLE
declare -ga SHELLNS_TYPES_AVAILABLE=()



#
# Regex

#
# Integer
if [ ! "${SHELLNS_TYPES_REGEX_INTEGER:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_INTEGER='^[-]?[0-9]+$'
fi
#
# Float
if [ ! "${SHELLNS_TYPES_REGEX_FLOAT:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_FLOAT='^([-]?[0-9]+)([.][0-9]+)?$'
fi



#
# charDecimal
if [ ! "${SHELLNS_TYPES_REGEX_CHARDECIMAL:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CHARDECIMAL='^[0-9]+$'
fi
#
# charHex
if [ ! "${SHELLNS_TYPES_REGEX_CHARHEX:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CHARHEX='^[0-9A-Fa-f]{1,2}$'
fi
#
# charOctal
if [ ! "${SHELLNS_TYPES_REGEX_CHAROCTAL:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CHAROCTAL='^[0-7]{3}$'
fi



#
# fileSystemPath
if [ ! "${SHELLNS_TYPES_REGEX_FILESYSTEMPATH:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_FILESYSTEMPATH='^[^/][a-zA-Z0-9._/-]*$'
fi
#
# dirName
if [ ! "${SHELLNS_TYPES_REGEX_DIRNAME:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DIRNAME='^[a-zA-Z0-9._-]+$'
fi
#
# fileName
if [ ! "${SHELLNS_TYPES_REGEX_FILENAME:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_FILENAME='^[a-zA-Z0-9._-]+$'
fi



#
# YYYY-MM-DDTHH:mm:ssZ
if [ ! "${SHELLNS_TYPES_REGEX_DATETIMELOCAL:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DATETIMELOCAL='^[0-9]{4}-((0[0-9]{1})|(1[0-2]{1}))-(([0-2]{1}[0-9]{1})|(3[0-1]{1}))T(([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}Z$'
fi
#
# YYYY-MM-DD HH:mm:ss
if [ ! "${SHELLNS_TYPES_REGEX_DATETIME:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DATETIME='^[0-9]{4}-((0[0-9]{1})|(1[0-2]{1}))-(([0-2]{1}[0-9]{1})|(3[0-1]{1})) (([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}$'
fi
#
# YYYY-MM-DD
if [ ! "${SHELLNS_TYPES_REGEX_DATE:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_DATE='^[0-9]{4}-(0[1-9]{1}|1[0-2]{1})-(0[1-9]{1}|1[0-9]{1}|2[0-9]{1}|3[0-1]{1})$'
fi
#
# YYYY-MM
if [ ! "${SHELLNS_TYPES_REGEX_MONTH:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_MONTH='^[0-9]{4}-(0[1-9]{1}|1[0-2]{1})$'
fi
#
# HH:mm:ss
if [ ! "${SHELLNS_TYPES_REGEX_HOUR:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_HOUR='^(([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}$'
fi
#
# HH:mm
if [ ! "${SHELLNS_TYPES_REGEX_MINUTE:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_MINUTE='^(([0-1]{1}[0-9]{1})|(2[0-3]{1})):[0-5]{1}[0-9]{1}$'
fi



#
# code
if [ ! "${SHELLNS_TYPES_REGEX_CODE:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_CODE='^\\'
fi
#
# color
if [ ! "${SHELLNS_TYPES_REGEX_COLOR:+exists}" ]; then
  readonly SHELLNS_TYPES_REGEX_COLOR='^\\e\[[0-9;]*m$'
fi





#
# The variables below store the result of the last validation done.
# Both the message and the output status.
SHELLNS_TYPES_LAST_VALIDATE_STATUS=""
SHELLNS_TYPES_LAST_VALIDATE_MESSAGE=""
# Store the list of values that were validated.
unset SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST
declare -ga SHELLNS_TYPES_LAST_VALIDATE_VALUES_LIST=()





#
# Labels
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
#!/usr/bin/env bash

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
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_GIVEN_VALUE="received: '**{{PH_VALUE}}**'"
SHELLNS_TYPES_LBL_ERROR_VALIDATE_INFO_EXPECTED_VALUES="expected: **{{PH_EXPECTED}}**"
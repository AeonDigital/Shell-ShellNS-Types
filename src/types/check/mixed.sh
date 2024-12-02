#!/usr/bin/env bash

#
# Checks if the passed value is a representative of a valid **mixed**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_mixed() {
  return 0
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("mixed")
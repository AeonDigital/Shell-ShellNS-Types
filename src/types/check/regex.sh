#!/usr/bin/env bash

#
# Checks if the passed value is a representative of a valid **regex**.
#
# @param mixed $1
# Value that will be tested.
#
# @return status
shellNS_types_check_regex() {
  #
  # OBS:
  # There is no sure way to do this validation. It is listed here so that it can
  # eventually be implemented.
  return 0
}

#
# Register type
SHELLNS_TYPES_AVAILABLE+=("regex")
# Copyright (c) 2026
# SPDX-License-Identifier: Apache-2.0

get_filename_component(NCS_ROOT "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)

list(APPEND ZEPHYR_EXTRA_MODULES
  "${NCS_ROOT}/modules/usp_zephyr"
  "${NCS_ROOT}/modules/lib/usp"
)

if(NOT DEFINED SHIELD OR "${SHIELD}" STREQUAL "")
  set(SHIELD semtech_wio_lr2021)
endif()

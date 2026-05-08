# Copyright (c) 2026
# SPDX-License-Identifier: Apache-2.0

get_filename_component(SEMTECH_SAMPLES_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

if(NOT DEFINED NCS_ROOT)
  if(DEFINED ENV{ZEPHYR_BASE})
    get_filename_component(NCS_ROOT "$ENV{ZEPHYR_BASE}/.." ABSOLUTE)
  else()
    get_filename_component(NCS_ROOT "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
  endif()
endif()

set(NCS_ROOT "${NCS_ROOT}" CACHE PATH "nRF Connect SDK root")

foreach(required_module
    "${NCS_ROOT}/modules/usp_zephyr"
    "${NCS_ROOT}/modules/lib/usp")
  if(NOT EXISTS "${required_module}")
    message(FATAL_ERROR
      "Required Semtech module not found: ${required_module}\n"
      "Set NCS_ROOT to the nRF Connect SDK root, or install usp_zephyr and usp "
      "under <NCS_ROOT>/modules.")
  endif()
endforeach()

list(APPEND DTS_ROOT "${SEMTECH_SAMPLES_ROOT}")

list(APPEND ZEPHYR_EXTRA_MODULES
  "${NCS_ROOT}/modules/usp_zephyr"
  "${NCS_ROOT}/modules/lib/usp"
)

if(NOT DEFINED SEMTECH_WIO_LR2021_OVERLAY)
  set(SEMTECH_WIO_LR2021_OVERLAY
    "${CMAKE_CURRENT_LIST_DIR}/../boards/semtech_wio_lr2021.overlay"
  )
endif()

list(APPEND EXTRA_DTC_OVERLAY_FILE "${SEMTECH_WIO_LR2021_OVERLAY}")

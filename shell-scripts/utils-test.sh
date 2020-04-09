#!/bin/bash

source /media/logic/utils/all-utils.sh

TRACE_OUT="$TRUE"
set_log_level "$LOG_LEVEL_DEBUG"


log_always "always-log"
log_error "error-log"
log_warn "warn-log"
log_info "info-log"
log_debug "debug-log"

find_parameter "i"
INPUT_FILE="$PARAMETER"

echo "test utils done"

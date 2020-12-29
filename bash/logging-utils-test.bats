TEST=./universal-function-test.sh

@test "log info" {
  $TEST logging-utils.sh log_info "this is a info"
}

@test "log error" {
  $TEST logging-utils.sh log_error "this is a info"
}

@test "log warn" {
  $TEST logging-utils.sh log_warn "this is a info"
}

@test "log debug" {
  $TEST logging-utils.sh log_debug "this is a info" 
}

@test "log trace" {
  $TEST logging-utils.sh log_trace "this is a info"
}

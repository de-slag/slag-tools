@test "utl-logging-utils-test ok_log_error_test_no_text" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_error_test
  [ "$status" = 0 ]
  [[ "$output" =~ "[ERROR]" ]]
}

@test "utl-logging-utils-test ok_log_error_test" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_error_test "something went wrong"
  [ "$status" = 0 ]
  [[ "$output" =~ "[ERROR] - something went wrong" ]]
}

@test "utl-logging-utils-test ok_log_info_test" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_info_test "this is an information"
  [ "$status" = 0 ]
  [[ "$output" =~ "[INFO] - this is an information" ]]
}

@test "utl-logging-utils-test ok_log_debug_test" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_debug_test "this is a debug info"
  [ "$status" = 0 ]
  [[ "$output" =~ "[DEBUG] - this is a debug info" ]]
}

@test "utl-logging-utils-test ok_log_debug_silence_test" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_debug_silence_test "this is a debug info"
  [ "$status" = 0 ]
  [[ "$output" = "" ]]
}

@test "utl-logging-utils-test ok_log_trace_test" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_trace_test "this is a trace info"
  [ "$status" = 0 ]
  [[ "$output" =~ "[TRACE] - this is a trace info" ]]
}

@test "utl-logging-utils-test ok_log_trace_silence_test" {
  run ./universal-function-test.sh ./utl-logging-utils-test.sh ok_log_trace_silence_test "this is a trace info"
  [ "$status" = 0 ]
  [[ "$output" = "" ]]
}

@test "utl-constants-test assert_timestamp_pattern" {
  run ./universal-function-test.sh ./utl-constants-test.sh assert_timestamp_pattern
  [ "$status" = 0 ]
  [[ "$output" = "+%Y-%m-%d_%H-%M-%S" ]]
}




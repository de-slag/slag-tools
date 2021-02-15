@test "utl-config-utils-test fails_wrong_file" {
  run ./universal-function-test.sh ./utl-config-utils-test.sh fails_wrong_file
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - configuration file not found: '" ]]
}

@test "utl-config-utils-test ok_no_value" {
  run ./universal-function-test.sh ./utl-config-utils-test.sh ok_no_value
  [ "$status" = 0 ]
  [[ "$output" = "" ]]
}

@test "utl-config-utils-test ok_with_value" {
  run ./universal-function-test.sh ./utl-config-utils-test.sh ok_with_value
  [ "$status" = 0 ]
  [[ "$output" = "Lorem ipsum dolor" ]]
}






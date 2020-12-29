@test "ok, argument found in long args list" {
  run ./universal-function-test.sh cli-args-utils.sh read_cli_argument -c "--test -c=xyz -a=abc"
  [ "$status" = 0 ]
  [[ "$output" =~ "found: '-c=xyz'" ]]
  [[ "$output" =~ "found value: 'xyz'" ]]

}

@test "ok, argument found" {
  run ./universal-function-test.sh cli-args-utils.sh read_cli_argument -c -c=xyz
  [ "$status" = 0 ]
  [[ "$output" =~ "found: '-c=xyz'" ]]
  [[ "$output" =~ "found value: 'xyz'" ]]

}

@test "ok, argument not found" {
  run ./universal-function-test.sh cli-args-utils.sh read_cli_argument -c -a=xyz
  [ "$status" = 0 ]
  [[ "$output" =~ "'-c' not found in '-a=xyz'" ]]
}

@test "ok, no arguments given" {
  run ./universal-function-test.sh cli-args-utils.sh read_cli_argument
  [ "$status" = 0 ]
  [[ "$output" =~ "no arguments given, return" ]]
}

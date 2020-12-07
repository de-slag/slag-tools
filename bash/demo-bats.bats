#setup() {
#   set -x
#}

@test "a universal test" {
  run ./universal-function-test.sh logging-utils.sh log_info "this is an info"
  [ "$status" = 0 ]
  [[ "$output" =~ "this is" ]]
}

@test "a test" {
  run ./demo.sh
  [ "$status" = 0 ]
  [[ "$output" =~ "this is a" ]]
}

@test "a simple test" {
  run echo "this is a test"
  [ "$status" = 0 ]
  [[ "$output" =~ test ]]
}

@test "very simple test" {
  ls
}

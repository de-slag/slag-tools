@test "a universal test" {
  run ./universal-function-test.sh demo.sh a_test "this is a test"
  [ "$status" = 0 ]
  [[ "$output" =~ "test-ing" ]]
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

# create a file 'demo.sh' and make it executable
# #!/bin/bash
# function a_test {
#   echo "$1-ing"
# }
# echo "this is a test"

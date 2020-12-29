@test "fails, number not setted" {
  run ./universal-function-test.sh performance-measure.sh is_prime
  [ "$status" = 1 ]
  [[ "$output" =~ "number is not setted. exit" ]]
}

@test "not a prime 0" {
  run ./universal-function-test.sh performance-measure.sh is_prime 0
  [[ "$output" =~ "'0' is not a prime" ]]
}

@test "not a prime 24" {
  run ./universal-function-test.sh performance-measure.sh is_prime 24
  [[ "$output" =~ "'24' is not a prime" ]]
}

@test "a prime 23" {
  run ./universal-function-test.sh performance-measure.sh is_prime 23
  [[ "$output" =~ "'23' is a prime" ]]
}

@test "a prime 7" {
  run ./universal-function-test.sh performance-measure.sh is_prime 7
  [[ "$output" =~ "'7' is a prime" ]]
}

@test "a prime 2" {
  run ./universal-function-test.sh performance-measure.sh is_prime 2
  [[ "$output" =~ "'2' is a prime" ]]
}


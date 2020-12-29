SUT=prime-utils.sh

@test "$SUT is prime 53" {
  run ./universal-function-test.sh prime-utils.sh is_prime 53
  [ "$status" = 0 ]
  [[ "$output" =~ "'53' is a prime" ]]
}

@test "$SUT is no prime 12" {
  run ./universal-function-test.sh prime-utils.sh is_prime 12
  [ "$status" = 0 ]
  [[ "$output" =~ "'12' is not a prime" ]]
}

@test "$SUT is no prime 4" {
  run ./universal-function-test.sh prime-utils.sh is_prime 4
  [ "$status" = 0 ]
  [[ "$output" =~ "'4' is not a prime" ]]
}


@test "$SUT is prime 2" {
  run ./universal-function-test.sh prime-utils.sh is_prime 2
  [ "$status" = 0 ]
  [[ "$output" =~ "'2' is a prime" ]]
}



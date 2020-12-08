
@test "assert_not_null" {
  ./universal-function-test.sh base-utils.sh assert_not_null a b
}

@test "assert_user_root" {
  run ./universal-function-test.sh base-utils.sh assert_user_root
  [ "$status" = 1 ]
  [[ "$output" =~ "user is not root" ]]	
}

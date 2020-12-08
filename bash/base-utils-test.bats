# script under test
SUT=base-utils.sh

@test "$SUT: assert_not_null" {
  ./universal-function-test.sh $SUT assert_not_null a b
}

@test "$SUT: assert_user_root" {
  run ./universal-function-test.sh $SUT assert_user_root
  [ "$status" = 1 ]
  [[ "$output" =~ "user is not root" ]]	
}

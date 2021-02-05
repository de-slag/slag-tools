# script under test
SUT=../bash/utl-base-utils.sh

@test "utl-base-utils.sh assert_not_null ok_test" {
  run ./universal-function-test.sh ./utl-base-utils-assert-not-null.sh ok_test
  [ "$status" = 0 ]
}

@test "utl-base-utils.sh assert_not_null value_null_test" {
  run ./universal-function-test.sh ./utl-base-utils-assert-not-null.sh value_null_test
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - a is NULL" ]]	
}

@test "utl-base-utils.sh assert_not_null value_description_null_test" {
  run ./universal-function-test.sh ./utl-base-utils-assert-not-null.sh value_description_null_test
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - value description is NULL" ]]	

}

@test "$SUT: assert_user_root" {
  run ./universal-function-test.sh $SUT assert_user_root
  [ "$status" = 1 ]
  [[ "$output" =~ "user is not root" ]]	
}

# script under test
SUT=../bash/utl-base-utils.sh
UNIVERSAL=./universal-function-test.sh

@test "utl-base-utils.sh assert_not_null ok_test" {
  run $UNIVERSAL ./utl-base-utils-assert-not-null.sh ok_test
  [ "$status" = 0 ]
}

@test "utl-base-utils.sh assert_not_null value_null_test" {
  run $UNIVERSAL ./utl-base-utils-assert-not-null.sh value_null_test
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - a is NULL" ]]	
}

@test "utl-base-utils.sh assert_not_null value_description_null_test" {
  run $UNIVERSAL ./utl-base-utils-assert-not-null.sh value_description_null_test
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - value description is NULL" ]]	
}

@test "utl-base-utils.sh assert_user_root" {
  run $UNIVERSAL $SUT assert_user_root
  [ "$status" = 1 ]
  [[ "$output" =~ "user is not root" ]]	
}

@test "utl-base-utils-test.sh ok_user_input_test" {
  run $UNIVERSAL ./utl-base-utils-test.sh user_input_test "this is a fancy UI test"
  [ "$status" = 0 ]
  [[ "$output" =~ "this is a fancy UI test" ]]	
}

@test "utl-base-utils-test.sh ok_user_input_test_no_text" {
  run $UNIVERSAL ./utl-base-utils-test.sh user_input_test
  [ "$status" = 0 ]
  [ "$output" == " " ]	
}

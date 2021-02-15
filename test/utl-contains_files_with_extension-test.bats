@test "utl-contains_files_with_extension-test ok_found_files_test" {
  run ./universal-function-test.sh ./utl-contains_files_with_extension-test.sh ok_found_files_test ~/slag-tools/bash sh
  [ "$status" = 0 ]
  [[ "$output" = "true" ]]
}

@test "utl-contains_files_with_extension-test ok_found_no_files_test" {
  run ./universal-function-test.sh ./utl-contains_files_with_extension-test.sh ok_found_files_test ~/slag-tools/bash xyz
  [ "$status" = 0 ]
  [[ "$output" = "false" ]]
}

@test "utl-contains_files_with_extension-test fail_no_valid_dir_test" {
  run ./universal-function-test.sh ./utl-contains_files_with_extension-test.sh ok_found_files_test /invalid/path xyz
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - not a valid directory: '/invalid/path'" ]]
}

@test "utl-contains_files_with_extension-test fail_parameter_extension_not_setted_test" {
  run ./universal-function-test.sh ./utl-contains_files_with_extension-test.sh ok_found_files_test ~/slag-tools/bash
  [ "$status" = 1 ]
  [[ "$output" =~ "[ERROR] - file extension not setted" ]]
}

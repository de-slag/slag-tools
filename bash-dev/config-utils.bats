SUT=config-utils.sh

@test "$SUT: split_key_value0: ok" {
  run ./universal-function-test.sh config-utils.sh split_key_value0 abc=123
  [ "$status" = 0 ]
  [[ "$output" =~ "splitted in: key: 'abc', value: '123'" ]]
}

@test "$SUT: read_config_value_from_line0: ok, line is empty" {
  run ./universal-function-test.sh config-utils.sh read_config_value_from_line0
  [ "$status" = 0 ]
  [[ "$output" =~ "line is empty, skipping" ]]
}

@test "$SUT: read_config_value_from_line0: ok" {
  run ./universal-function-test.sh config-utils.sh read_config_value_from_line0 abc=123
  [ "$status" = 0 ]
  [[ "$output" =~ "key: 'abc', value: '123'" ]]
}

@test "$SUT: assert_properties_file0: not ok: configuration file not found" {
  run ./universal-function-test.sh config-utils.sh assert_properties_file0 /invalid/file
  [ "$status" = 1 ]
  [[ "$output" =~ "configuration file not found: '/invalid/file'" ]]
}

@test "$SUT: assert_properties_file0" {
  run ./universal-function-test.sh config-utils.sh assert_properties_file0 ~/slag-configurations/global.properties
  [ "$status" = 0 ]
  [[ "$output" =~ "config file found: $properties_file" ]]
}




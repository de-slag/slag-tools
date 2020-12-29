TESTFILE=/tmp/global-config-utils-test.properties
SUT=global-config-utils.sh
setup() {
  echo "test.one=ONE" > $TESTFILE 
  echo "test.two=2" >> $TESTFILE
  echo "#eof" >> $TESTFILE
}

@test "$SUT: read_config_value: ok, file specified, parameter found" {
  run ./universal-function-test.sh global-config-utils.sh read_config_value test.two $TESTFILE
  [ "$status" = 0 ]
  [[ "$output" =~ "config value found: '2'" ]]
}

@test "$SUT: read_config_value: ok, file specified, parameter not found" {
  run ./universal-function-test.sh global-config-utils.sh read_config_value test.parameter $TESTFILE
  [ "$status" = 0 ]
   [[ "$output" =~ "config key 'test.parameter' not found in file '/tmp/global-config-utils-test.properties'" ]]
}

@test "$SUT: read_config_value: ok, config file not specified, use default file, parameter found" {
  run ./universal-function-test.sh global-config-utils.sh read_config_value test.one
  [ "$status" = 0 ]
  [[ "$output" =~ "config value found: 'One'" ]]
}

@test "$SUT: read_config_value: ok, config file not specified, use default file, parameter not found" {
  run ./universal-function-test.sh global-config-utils.sh read_config_value test.parameter
  [ "$status" = 0 ]
  [[ "$output" =~ "config key 'test.parameter' not found in file '".*"/slag-configurations/global.properties'" ]]
}

@test "$SUT: read_config_value: fails, no properties file" {
  run ./universal-function-test.sh global-config-utils.sh read_config_value test.parameter /invalid/file
  [ "$status" = 1 ]
  [[ "$output" =~ "property file not found: '/invalid/file'. exit" ]]
}

@test "$SUT: read_config_value: ok, no parameter" {
  run ./universal-function-test.sh global-config-utils.sh read_config_value
  [ "$status" = 0 ]
  [[ "$output" =~ "no config key setted, return" ]]
}

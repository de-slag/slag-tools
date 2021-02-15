#!/bin/bash

source ../bash/utl-config-utils.sh

CONFIG_FILE=../test-resources/test.properties

function fails_wrong_file {
  CONFIG_FILE=/invalid/file.properties
  read_config_value "test.lorem.ipsum"
  echo "$CONFIG_VALUE"
}

function ok_no_value {
  read_config_value "key.with.no.value"
  echo "$CONFIG_VALUE"
}

function ok_with_value {
  read_config_value "test.lorem.ipsum"
  echo "$CONFIG_VALUE"
}

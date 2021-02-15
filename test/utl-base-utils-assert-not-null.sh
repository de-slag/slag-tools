#!/bin/bash

source ~/slag-tools/bash/utl-base-utils.sh

function ok_test {
  assert_not_null a b
}

function value_null_test {
  assert_not_null a
}

function value_description_null_test {
  assert_not_null
}

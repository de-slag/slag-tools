#!/bin/bash
clear

source utils-base-1-01.sh
#source utils-log-1-01.sh

log_always "setup..." main

validate_log_level
validate_properties_file
log_always "setup complete!\n" main


function read_and_print_property {
  read_property $1
  log_info "$1: '$PROPERTY'" main
}

read_and_print_property "abc"
read_and_print_property "test"




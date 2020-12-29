#!/bin/bash

source utils-log-1-01.sh

PROPERTIES_FILE=
PROPERTY=

function assert_not_null {
  local value_name=$1
  local value=$2
  log_trace "value_name: '$value_name', value: '$value'" BASEUTILS.assert_not_null
 
  if [ -z $value ] ; then
    if [ -z $value_name ] ; then
	  log_fatal "cannot create error message: value and value-name is NULL" BASEUTILS.assert_not_null
	  exit 2
	fi	
  
    log_error "is null '$value_name'" BASEUTILS.assert_not_null
	exit 1
  fi
  
  log_trace "OK: '$value_name' is not null, value: '$value'" BASEUTILS.assert_not_null
}

function set_properties_file {
  local properties_file=$1
  assert_not_null "properties_file_name" "$properties_file"
  
  if [ ! -f $properties_file ] ; then
    log_error "set_properties_file - '$properties_file' is not a regular file"
    exit 1
  fi
  PROPERTIES_FILE=$properties_file
  log_debug "using properties file: '$PROPERTIES_FILE'" BASEUTILS.set_properties_file
}


function read_property {
  local property_name=$1
  PROPERTY=
  log_trace "read_property:property_name '$property_name'" BASEUTILS.read_property
  assert_not_null "PROPERTIES_FILE" $PROPERTIES_FILE
  assert_not_null "read_property:property name" $property_name
  
  
  local input=$PROPERTIES_FILE
  while IFS= read -r line
  do
    log_trace "parse line '$line'" read_property
    local tmp_ifs=$IFS
	IFS="="
	local key_value=($line)
	IFS=$tmp_ifs
	local key=${key_value[0]}
	local value=${key_value[1]}
	
	log_trace "parsed line: key='$key', value='$value'" BASEUTILS.read_property

	if [ "$property_name" == "$key" ] ; then
	  log_trace "property '$key' found. value: '$value'" BASEUTILS.read_property
	  PROPERTY=$value
	  return 0
	else
	  log_trace "property '$key' is not '$property_name'" BASEUTILS.read_property
	fi
    
  done < "$input"
  
  log_warn "no property found with name: '$property_name'" BASEUTILS.read_property
}

function read_default_cli_params {

  log_debug "..." BASEUTILS.read_default_cli_params

  POSITIONAL=()
  while [[ $# -gt 0 ]]
  do
    key="$1"
	log_debug "processing: '$key'..." BASEUTILS.read_default_cli_params

    case $key in
      --properties)
      PROPERTIES_FILE="$2"
	  log_debug "set variable 'PROPERTIES_FILE' to '$PROPERTIES_FILE'" BASEUTILS.read_default_cli_params
      shift # past argument
      shift # past value
      ;;
	  --loglevel)
	  LOG_LEVEL=$2
	  log_debug "set variable 'LOG_LEVEL' to '$LOG_LEVEL'" BASEUTILS.read_default_cli_params
	  shift # past argument
      shift # past value
	  ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
    esac
  done
  set -- "${POSITIONAL[@]}" # restore positional parameters
  log_info "done" BASEUTILS.read_default_cli_params
}

function validate_properties_file {
  set_properties_file "$PROPERTIES_FILE"
  log_info "done" BASEUTILS.validate_properties_file
}

function setup_base_utils {
  setup_log_utils
  log_info "setup log utils done." setup_base_utils
  validate_properties_file
}

echo "Base Utils $version"
echo "for setup call 'setup_base_utils'"
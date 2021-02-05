#!/bin/bash

source ~/slag-tools/bash/core-script.sh

MANAGED_USER=sivas

function lock_user {
  chage -E0 $MANAGED_USER
  log_info "user locked: $MANAGED_USER"
}

function unlock_user {
  chage -E-1 $MANAGED_USER
  log_info "user unlocked: $MANAGED_USER"
}

function logout_user {
  log_debug "logout user, assert that managed user is not root..'"
  if [ "root" == "$MANAGED_USER" ] ; then
    log_error "logout user 'root' is not provided. exit."
    exit 1
  fi
  log_debug "ok. log out user '$MANAGED_USER'.."

  log_info "check if user is logged in.."
  local user_info=$(users | grep $MANAGED_USER)
  log_debug "user info: '$user_info'"
  if [ -z "$user_info" ] ; then
    log_info "user is not logged in: '$MANAGED_USER'. return."
    return
  fi

  log_info "user is logged in: '$MANAGED_USER', log out."
  pkill -KILL -u $MANAGED_USER
  log_info "user logged out: '$MANAGED_USER'"
}

USER_ACCESS_ALLOWED=
function isAccessAllowed {
  USER_ACCESS_ALLOWED=false
  #USER_ACCESS_ALLOWED=true
}

isAccessAllowed
if [ $USER_ACCESS_ALLOWED == true ] ; then
  log_info "user access allowed for: '$MANAGED_USER'"
  unlock_user
  exit
fi
log_info "user access NOT allowed for: '$MANAGED_USER'"
lock_user
logout_user

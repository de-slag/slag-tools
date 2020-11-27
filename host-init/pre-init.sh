#!/bin/bash

function log {
  printf "$1\n"
}

function log_error {
  log "ERROR: $1"
}

function log_info {
  log "INFO: $1"
}

function pull_git_repos {
  local git_repos=$1
  if [ -z $git_repos ] ; then
    log_error "git_repos is empty"
    exit 1
  fi
  
  log_info "pullig git repos: $git_repos..."

  OIFS=$IFS
  IFS=';'

  for git_repo in $git_repos
  do
    log_info "pull git repo: $git_repo.."
    # git pull $git_repo
    log_info "pull git repo: $git_repo. done."
  done
  IFS=$OIFS
  log_info "pullig git repos: $git_repos. done."

}

sudo apt-get install git

pull_git_repos $1
log_info "all done!"

#!/bin/bash

repositories="slag-configurations slag-tools"
branches="develop master"

function pull_repo_branch {
  local repo=$1
  local branch=$2
  echo "pulling $repo $branch"

  cd ~
  if [ ! -d $repo ] ; then
    echo "repo not found: '$repo'. return."
    return
  fi
  cd $repo
  local branch_info=$(git branch | grep $branch)
  if [ -z "$branch_info" ] ; then
     echo "branch not found: '$branch' on repo '$repo'. return."
    return 
  fi
  git checkout $branch
  git pull
}

function pull_repo {
  local repo=$1
  for branch in $branches ; do
    pull_repo_branch $repo $branch
  done
}

for repo in $repositories ; do
  pull_repo $repo
done

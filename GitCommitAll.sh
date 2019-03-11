#!/bin/sh

# File:        GitCommitAll.sh
# Author:      Petr Fusek
# Last change: 29.02.2019
#
# Description:
#   Agregated git add-commit command for all changes in repository including all submodule repositories.
#   All with single shared commit message.
#
# Usage:
#     ./GitCommitAll.sh [git <expr>] [commit <message string>]
#
#   git    <expr>           - git command to be executed for repository and all submodules
#   commit <message string> - If specified, git commit is executed for all repoziories
#                           - with same commit message
#
# Note:
#   If more options is specified execution order will be by order of commands in usage,
#   Actual order of parameters nodes not matter
#
# Restrictions:
#   combination add + push without commit is not allowed
#
#

# set -o xtrace

b_debug="0"
s_commitMessage=""
s_gitCommand=""
b_resetOneCommit="0"

AbortIfEmpty() {
  if [ -z $1 ]; then
    echo "$2"
    exit
  fi
}

ApplyGitCommandToAll() {
  echo "ApplyGitCommandToAll: $1"
  git submodule foreach --recursive "$1"
  eval "$1"
}

dStep() {
  if [ "$b_debug" = "1" ]; then
    echo ''
    echo "Step: $1"
    echo "--------------------------------------------------------------------------------------"
    read -s -n 1 key
    if [ "$key" = $'\e' ]; then
      exit
    fi
  fi
  eval "$1"
}

i_paramIndex="1"
while [ `expr "$i_paramIndex" \<= "$#"` != "0" ]; do                        # while(i_paramIndex <= argc) {
  s_nextParam=""                                                            #   s_nextParam="";
  s_actParam=$(eval echo "\$$i_paramIndex")                                 #   s_actParam = args[i_paramIndex];
  i_paramIndex="`expr $i_paramIndex + 1`"                                   #   i_paramIndex++;
  if [ `expr "$i_paramIndex" \<= "$#"` ]; then                              #   if (s_nextParam <= argc) {
    s_nextParam="$(eval echo "\$$i_paramIndex")"                            #     s_nextParam = args[i_paramIndex];
  fi                                                                        #   }
  case "$s_actParam" in                                                     #   switch(s_actParam) {
    "commit")                                                               #     case "commit":
      AbortIfEmpty "$s_nextParam" "Commit option must have specified value" #       AbortIfEmpty(s_nextParam, "Commit option must have specified value");
      s_commitMessage="$s_nextParam"                                       #       s_commitMessage=s_nextParam;
      i_paramIndex="`expr $i_paramIndex + 1`"                               #       i_paramIndex++;
      ;;                                                                    #       break;
    "git")                                                                  #     case "git":
      AbortIfEmpty     \
        "$s_nextParam" \
        "git custom command option must have specified value"               #       AbortIfEmpty(s_nextParam, "git custom command option must have specified value");
      s_gitCommand=$s_nextParam                                             #       s_gitCommand=s_nextParam;
      i_paramIndex="`expr $i_paramIndex + 1`"                               #       i_paramIndex++;
      ;;                                                                    #       break;
    "d")                                                                    #     case "d":
      b_debug="1"                                                           #       b_debug="1";
      ;;                                                                    #       break;
    "resetOne")                                                             #     case "resetOne":
      b_resetOneCommit="1"                                                  #       b_resetOneCommit="1";
      ;;                                                                    #       break;
    *)                                                                      #     default:
      echo "Unknown argument: \"$s_actParam\""                              #       print("Unknown argument: " + s_actParam);
      exit                                                                  #       exit;
      ;;                                                                    #       break;
  esac                                                                      #   }
done                                                                        # }

s_actBranch=$(git branch | grep \* | cut -d ' ' -f2)

if [ "$b_resetOneCommit" = "1" ]; then
  dStep "ApplyGitCommandToAll \"git checkout --force $s_actBranch\""
  dStep "ApplyGitCommandToAll \"git reset --soft HEAD~1\""
  dStep "ApplyGitCommandToAll \"git push --force\""
  exit
fi

if [ -n "$s_gitCommand" ]; then
  dStep "ApplyGitCommandToAll \"git $s_gitCommand\""
fi

if [ -n "$s_commitMessage" ]; then
  dStep "ApplyGitCommandToAll \"git add .\""
  dStep "git submodule foreach git commit -m \"$s_commitMessage\""
  dStep "git add ."
  dStep "git commit -m \"$s_commitMessage\""

  dStep "git submodule foreach git pull"
  dStep "git pull"

  dStep "git submodule foreach git push origin $s_actBranch"
  # dStep "git submodule foreach git checkout $s_actBranch"
  # dStep "git submodule update"
  dStep "git push"

  dStep "git status"
  dStep "git log --oneline --graph --all"
  dStep "git submodule foreach git log --oneline --graph --all"
fi

# ./GitCommitAll.sh d commit "Common build direcotry with new git commit script file and copying dlls form packages"

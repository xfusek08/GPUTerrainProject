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
#     ./GitCommitAll.sh [add <epr>] [commit <message string>] [push]
#
#   add    <epr>            - If specified, git add command is used before commiting.
#   commit <message string> - If specified, git commit is executed for all repoziories
#                           - with same commit message
#   push                    - If specified, git push to all repositories is executed
#
# Restrictions:
#   combination add + push without commit is not allowed
#

# set -o xtrace

AbortIfEmpty() {
  if [ -z $1 ]; then
    echo "$2"
    exit
  fi
}

TryApplyGitCommand() {
  git submodule foreach --recursive "$1"
  eval "$1"
}

s_addArg=""
s_commintMessage=""
s_actBranch=$(git branch | grep \* | cut -d ' ' -f2)
b_push="0"

i_paramIndex="1"
while [ `expr "$i_paramIndex" \<= "$#"` != "0" ]; do                        # while(i_paramIndex <= argc) {
  s_nextParam=""                                                            #   s_nextParam="";
  s_actParam=$(eval echo "\$$i_paramIndex")                                 #   s_actParam = args[i_paramIndex];
  i_paramIndex="`expr $i_paramIndex + 1`"                                   #   i_paramIndex++;
  if [ `expr "$i_paramIndex" \<= "$#"` ]; then                              #   if (s_nextParam <= argc) {
    s_nextParam=$(eval echo "\$$i_paramIndex")                              #     s_nextParam = args[i_paramIndex];
  fi                                                                        #   }
  case "$s_actParam" in                                                     #   switch(s_actParam) {
    "add")                                                                  #     case "add":
      AbortIfEmpty "$s_nextParam" "Add option must have specified value"    #       AbortIfEmpty(s_nextParam, "Add option must have specified value");
      s_addArg="$s_nextParam"                                               #       s_addArg=s_nextParam;
      i_paramIndex="`expr $i_paramIndex + 1`"                               #       i_paramIndex++;
      ;;                                                                    #       break;
    "commit")                                                               #     case "commit":
      AbortIfEmpty "$s_nextParam" "Commit option must have specified value" #       AbortIfEmpty(s_nextParam, "Commit option must have specified value");
      s_commintMessage="$s_nextParam"                                       #       s_commintMessage=s_nextParam;
      i_paramIndex="`expr $i_paramIndex + 1`"                               #       i_paramIndex++;
      ;;                                                                    #       break;
    "push")                                                                 #     case "push":
      b_push="1"                                                            #       b_push="1";
      ;;                                                                    #       break;
    *)                                                                      #     default:
      echo "Unknown argument: \"$s_actParam\""                              #       print("Unknown argument: " + s_actParam);
      exit                                                                  #       exit;
      ;;                                                                    #       break;
  esac                                                                      #   }
done                                                                        # }

echo "Options:"
echo "  s_addArg:         \"$s_addArg\""
echo "  s_commintMessage: \"$s_commintMessage\""
echo "  b_push:           \"0\""
echo "  s_actBranch:      \"$s_actBranch\""

# check if arguments aren't in not allowed combination
if                              \
  [ -n "$s_addArg" ] &&         \
  [ -z "$s_commintMessage" ] && \
  [ "$b_push" = "1" ]
then
  echo "combination of add and push is not allowed without defined commit"
  exit
fi

if [ -n "$s_addArg" ]; then
  TryApplyGitCommand "git add $s_addArg"
fi

if [ -n "$s_commintMessage" ]; then
  TryApplyGitCommand "git commit -m \"$s_commintMessage\""
  b_push="1"
fi

if [ "$b_push" = "1" ]; then
  git pull
  git submodule foreach git pull
  git submodule foreach git push origin master
  git submodule foreach git checkout $s_actBranch
  git push
fi

git status
git log --oneline --graph --all
git submodule foreach git log --oneline --graph --all

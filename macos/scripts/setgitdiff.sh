#! /bin/bash
SCRIPT_PATH=$(dirname "$0")            # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

git config --global merge.tool meld
git config --global diff.guitool meld
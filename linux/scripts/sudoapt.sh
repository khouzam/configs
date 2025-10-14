#! /bin/bash

SCRIPT_PATH=$(dirname "$0") # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]]; then
    # error; for some reason, the path is not accessible
    # to the script (e.g. permissions re-evaled after suid)
    exit 1 # fail
fi

SUDOFILE=/etc/sudoers.d/$USER

sudo cp -s -f $SCRIPT_PATH/../config/sudoers $SUDOFILE
sudo sed -i "s/__USER__/$USER/g" $SUDOFILE
sudo chown root:root $SUDOFILE
sudo chmod 440 $SUDOFILE

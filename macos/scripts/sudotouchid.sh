#! /bin/bash

SCRIPT_PATH=$(dirname "$0") # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]]; then
    # error; for some reason, the path is not accessible
    # to the script (e.g. permissions re-evaled after suid)
    exit 1 # fail
fi

VERSION_NUMBER=$(sw_vers --productVersion | cut -f1 -d'.')
if [[ $VERSION_NUMBER -lt 14 ]]; then
    OUTPUT_FILE='/etc/pam.d/sudo'
else
    OUTPUT_FILE='/etc/pam.d/sudo_local'
    if [[ ! -e $OUTPUT_FILE ]]; then
        sudo echo "# sudo_local: local config file which survives system update and is included for sudo" | sudo tee $OUTPUT_FILE
    fi
fi

if [[ ! -e '/usr/local/lib/pam/pam_watchid.so.2' ]]; then
    if [[ ! -e '/usr/local/lib/pam' ]]; then
        sudo mkdir -p '/usr/local/lib/pam'
    fi

    pushd $SCRIPT_PATH
    sudo cp ../bins/pam_watchid.so.2 /usr/local/lib/pam/
fi

if ! grep -q pam_watchid.so $OUTPUT_FILE; then
    echo Adding WatchID to sudo
    sudo sed -i '' -e '/^#/a\'$'\n''auth       sufficient     pam_watchid.so' $OUTPUT_FILE
fi

if ! grep -q pam_tid.so $OUTPUT_FILE; then
    echo Adding TouchID to sudo
    sudo sed -i '' -e '/^#/a\'$'\n''auth       sufficient     pam_tid.so' $OUTPUT_FILE
fi

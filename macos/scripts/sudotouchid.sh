#! /bin/bash

VERSION_NUMBER=$(sw_vers --productVersion | cut -f1 -d'.')
if [[ $VERSION_NUMBER -lt 14 ]]; then
    OUTPUT_FILE='/etc/pam.d/sudo'
else
    OUTPUT_FILE='/etc/pam.d/sudo_local'
    if [[ ! -e $OUTPUT_FILE ]]; then
        echo "# sudo_local: local config file which survives system update and is included for sudo" > $OUTPUT_FILE
    fi
fi

if ! grep -q pam_watchid.so $OUTPUT_FILE; then
    echo Adding WatchID to sudo
    sudo sed -i '' -e '/^#/a\'$'\n''auth       sufficient     pam_watchid.so' $OUTPUT_FILE
fi

if ! grep -q pam_tid.so $OUTPUT_FILE; then
    echo Adding TouchID to sudo
    sudo sed -i '' -e '/^#/a\'$'\n''auth       sufficient     pam_tid.so' $OUTPUT_FILE
fi

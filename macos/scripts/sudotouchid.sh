#! /bin/bash

if ! grep -q pam_watchid.so /etc/pam.d/sudo; then
    echo Adding WatchID to sudo
    sudo sed -i '' -e '/^#/a\'$'\n''auth       sufficient     pam_watchid.so' /etc/pam.d/sudo
fi

if ! grep -q pam_tid.so /etc/pam.d/sudo; then
    echo Adding TouchID to sudo
    sudo sed -i '' -e '/^#/a\'$'\n''auth       sufficient     pam_tid.so' /etc/pam.d/sudo
fi

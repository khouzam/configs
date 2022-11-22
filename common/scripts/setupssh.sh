#! /bin/bash

setssh() { #$1=LastpassKey, $2=OutputFile and Host, $3=User
    local key=$1
    local out=$2
    local user=$3
    echo -e "Getting $1"
    lpass show --field='Private Key' "$1" > $SSHDIR/$2
    chmod 600 $SSHDIR/$2
    local hostname=$(lpass show --field=Hostname "$1")
    echo -e "Host "$out $hostname"\n\tHostName "$hostname"\n\tIdentityFile "$SSHDIR"/"$out"\n\tUser "$user"\n\n ">> $SSHDIR/config
}

SSHDIR=~/.ssh


# Login to lastpass
lpass login gilles@khouzam.com
lpass sync

setssh "Github SSH" github git
setssh "PiHole SSH" pihole pi
setssh "Home SSH" home gilles
setssh "Kitware Gitlab SSH" kitware git
setssh "Magikinfo Devops SSH" magikinfo git
setssh "Magikinfo VisualStudio SSH" visualstudio magikinfo

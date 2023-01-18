#! /bin/bash

setssh() { #$1=LastpassKey, $2=OutputFile and Host, $3=User, $4=Port
    local key=${1}
    local out=${2}
    local user=${3}
    local port=${4}
    local hosts=${out}
    echo -e "Getting ${1}"
    lpass show --field='Private Key' "$1" >${SSHDIR}/$2
    chmod 600 ${SSHDIR}/$2
    local hostname=$(lpass show --field=Hostname "${1}")

    if [[ ! "${out}" == "${hostname}" ]]; then
        hosts="${out} ${hostname}"
    fi

    local cmdString="Host ${hosts}\n\tHostName ${hostname}\n\tIdentityFile ${SSHDIR}/${out}\n\tUser ${user}\n"
    if [[ ! -z ${port} ]]; then
        cmdString="${cmdString}\tPort ${port}\n"
    fi

    echo -e ${cmdString} >>${SSHDIR}/config
}

SSHDIR=~/.ssh
if [[ ! -d ${SSHDIR} ]]; then
    mkdir ${SSHDIR}
fi

# Login to lastpass
lpass login gilles@khouzam.com
lpass sync

setssh "Home SSH" mudflaps gilles
setssh "Home SSH" kraken gilles 23
setssh "Home SSH" gilles-air gilles 24
setssh "Home SSH" gilles-air-wifi gilles 25
setssh "PiHole SSH" pihole pi
setssh "Github SSH" github git
setssh "Kitware Gitlab SSH" kitware git
setssh "Magikinfo Devops SSH" magikinfo git
setssh "Magikinfo VisualStudio SSH" visualstudio magikinfo

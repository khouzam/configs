#! /bin/bash
SCRIPT_PATH=$(dirname "$0") # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]]; then
    # error; for some reason, the path is not accessible
    # to the script (e.g. permissions re-evaled after suid)
    exit 1 # fail
fi

# Parse arguments
INSTALL_GUI=true
for arg in "$@"; do
    if [[ "$arg" == "--no-gui" ]]; then
        INSTALL_GUI=false
    fi
done

pushd $SCRIPT_PATH

is_installed() {
    if [[ "${installer}" == "dnf" ]]; then
        dnf list installed "$1" >/dev/null 2>&1
    elif [[ "${installer}" == "apt" ]]; then
        $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -q "ok installed")
    fi
}

pkg_install() {
    echo "Installing $1 using ${installer}"
    if is_installed $1; then
        echo "$1 is already installed"
    else
        sudo ${installer} install -y $* && echo "$1 is installed"
    fi
}

run_script() {
    if [[ -f $1 ]]; then
        echo "Running $1 script"
        $1
    fi
}

set_default_shell() {
    if ! grep "^$USER" /etc/passwd | grep $1 >/dev/null; then
        echo "$1 is not the default shell"
        shell=$(command -v $1)
        if [[ ! -z "$shell" ]]; then
            chsh -s $shell
            echo "Changed default shell for the user to: $shell"
        else
            echo "Could not find an executable for $1, leaving the shell alone"
        fi
    fi
}

if [[ ! -d ~/.config ]]; then
    mkdir ~/.config
fi

if command -v apt >/dev/null; then
    echo "Using apt based install"
    installer="apt"
    # Update apt
    sudo apt update
    sudo apt upgrade -y

elif command -v dnf >/dev/null; then
    echo "Using dnf based install"
    installer="dnf"
else
    echo "I have no Idea what im doing here"
    exit 1
fi

pkg_install curl
pkg_install coreutils
pkg_install tmux
pkg_install lastpass-cli
pkg_install zsh
pkg_install gh

## Install packages that have a gui optionally
if [[ "$INSTALL_GUI" == "true" ]]; then
    pkg_install git-gui
    pkg_install neofetch
else
    pkg_install neofetch --no-install-recommends
fi

run_script $SCRIPT_PATH/../common/scripts/installzsh.sh

echo Checking and Installing Speedtest
if ! is_installed speedtest; then
    echo Installing speedtest
    pkg_install curl

    if [[ "${installer}" == "dnf" ]]; then
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
    elif [[ "${installer}" == "apt" ]]; then
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    fi

    pkg_install speedtest
else
    echo Speedtest is installed
fi

# echo Checking and installing Cloudflared
# if ! is_installed cloudflared; then
#     echo Installing cloudflared
#     if [[ "${installer}" == "yum" ]]; then
#         sudo yum install -y yum-utils
#         sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
#         sudo yum -y install cloudflared
#     elif [[ "${installer}" == "apt" ]]; then
# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared# fi
# fi

# Set the default shell to zsh if not already
set_default_shell zsh

# Run the config scripts
run_script $SCRIPT_PATH/scripts/sudoapt.sh
run_script $SCRIPT_PATH/../common/scripts/linkconfigs.sh
run_script $SCRIPT_PATH/../common/scripts/setgit.sh

# Create a docker group and add the user to it
if [ ! $(getent group docker) ]; then
    echo "Creating docker group"
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

popd

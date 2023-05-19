#! /bin/bash
SCRIPT_PATH=$(dirname "$0") # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]]; then
    # error; for some reason, the path is not accessible
    # to the script (e.g. permissions re-evaled after suid)
    exit 1 # fail
fi

pushd $SCRIPT_PATH

is_installed() {
    if [[ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
        return 1
    else
        return 0
    fi
}

apt_install() {
    echo "Installing $1 using apt"
    if is_installed $1; then
        echo "$1 is already installed"
    else
        sudo apt install -y $* && echo "$1 is installed"
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

# Update apt
sudo apt update
sudo apt upgrade -y

apt_install coreutils
apt_install lastpass-cli
apt_install zsh
apt_install gh
apt_install git-gui

# Install oh-my-zsh: https://ohmyz.sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k: https://github.com/romkatv/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo Checking and Installing Speedtest
if ! is_installed speedtest; then
    echo Installing speedtest
    apt_install curl

    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    apt_install speedtest
else
    echo Speedtest is installed
fi

# Set the default shell to zsh if not already
set_default_shell zsh

# Run the config scripts
run_script $SCRIPT_PATH/scripts/sudoapt.sh
run_script $SCRIPT_PATH/../common/scripts/linkconfigs.sh
run_script $SCRIPT_PATH/../common/scripts/setgit.sh

popd

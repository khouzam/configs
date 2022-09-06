#! /bin/bash
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

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

if [[ ! -f ~/.config ]]; then
    mkdir ~/.config
fi

sudo ln -s -f $MY_PATH/config/sudoers /etc/sudoers.d/$USER
sudo chown root:root $MY_PATH/config/sudoers

# Update apt
sudo apt update
sudo apt upgrade -y

apt_install coreutils
apt_install lastpass-cli
apt_install zsh
apt_install python3-pip
sudo pip3 install powerline-status
sudo pip3 install powerline-gitstatus

# Install oh-my-zsh: https://ohmyz.sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  "" --unattended

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

# Powerline fonts installation
echo Installing Powerline Fonts
tmp_dir=$(mktemp -d -t powerlinefonts.XXXXX)
pushd $tmp_dir
git clone https://github.com/powerline/fonts.git --depth=1 fonts
cd fonts
./install.sh
popd
rm -rf $tmp_dir
unset tmp_dir

# Configure Git
# Set the global user name (which might be changed)
git config --global user.name "Gilles Khouzam"
git config --global user.email gilles@khouzam.com
git config --global fetch.prune true
git config --global pull.rebase true
git config --global diff.colorMoved zebra

# Set the repo user name (which might be different than the global one eventually)
git config user.name "Gilles Khouzam"
git config user.email gilles@khouzam.com

# Link resource files
ln -s -f $MY_PATH/config/.inputrc ~/.inputrc
ln -s -f $MY_PATH/config/.bashrc ~/.bashrc
ln -s -f $MY_PATH/config/.bash_profile ~/.bash_profile
ln -s -f $MY_PATH/config/.bash_aliases ~/.bash_aliases

# ZSH configs
ln -s -f $MY_PATH/config/.zshenv ~/.zshenv
ln -s -f $MY_PATH/config/.zshrc ~/.zshrc
ln -s -f $MY_PATH/config/.zsh_aliases ~/.zsh_aliases
ln -s -f $MY_PATH/config/.p10k.zsh ~/.p10k.zsh

ln -s -f $MY_PATH/config/.powerlinerc ~/.powerlinerc
ln -s -f $MY_PATH/../powerline ~/.config/powerline

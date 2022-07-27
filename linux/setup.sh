#! /bin/bash
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

if [[ ! -f ~/.config ]]; then
    mkdir ~/.config
fi

ln -s -f $MY_PATH/config/.inputrc ~/.inputrc
ln -s -f $MY_PATH/config/.bashrc ~/.bashrc
ln -s -f $MY_PATH/config/.bash_profile ~/.bash_profile
ln -s -f $MY_PATH/config/.bash_aliases ~/.bash_aliases
ln -s -f $MY_PATH/config/.powerlinerc ~/.powerlinerc
ln -s -f $MY_PATH/../powerline ~/.config/powerline

sudo ln -s -f $MY_PATH/config/sudoers /etc/sudoers.d/$USER
sudo chown root:root $MY_PATH/config/sudoers

# Update apt
sudo apt update
sudo apt upgrade -y

# Powerline installation
echo installing Powerline Fonts
mkdir -p ~/projects/powerlinefonts
cd ~/projects/powerlinefonts
git clone https://github.com/powerline/fonts.git --depth=1 fonts
cd fonts
./install.sh

echo installing powerline
sudo apt install -y python3-pip
sudo pip3 install powerline-status
sudo pip3 install powerline-gitstatus

echo installing Lastpass
sudo apt install -y lastpass-cli

echo installing Speedtest
sudo apt install -y curl
curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
sudo apt install -y speedtest

#Configure Git
# Set the global user name (which might be changed)
git config --global user.name "Gilles Khouzam"
git config --global user.email gilles@khouzam.com

# Set the repo user name (which might be different than the global one eventually)
git config user.name "Gilles Khouzam"
git config user.email gilles@khouzam.com

git config --global fetch.prune true
git config --global pull.rebase true
git config --global diff.colorMoved zebra

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

echo Checking installation of mktemp
if [[ ! -x $(command -v mktemp) ]]; then
    echo Installing mktemp
    sudo apt install -y coreutils
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


echo Checking and installing pip3
if [[ ! -x $(command -v pip3) ]]; then
    echo Installing pip3
    sudo apt install -y python3-pip
fi

sudo pip3 install powerline-status
sudo pip3 install powerline-gitstatus

echo Checking and Installing lastpass-cli
if [[ ! -x $(command -v lpass) ]]; then
    echi Installing lastpass-cli
    sudo apt install -y lastpass-cli
fi

echo Checking and Installing Speedtest
if [[ ! -x $(command -v speedtest) ]]; then
    if [[ ! -x $(command -v curl) ]]; then
        sudo apt install -y curl
    fi

    curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
    sudo apt update
    sudo apt install -y speedtest
else
    echo Speedtest is installed
fi

# Configure Git
# Set the global user name (which might be changed)
git config --global user.name "Gilles Khouzam"
git config --global user.email gilles@khouzam.com

# Set the repo user name (which might be different than the global one eventually)
git config user.name "Gilles Khouzam"
git config user.email gilles@khouzam.com

git config --global fetch.prune true
git config --global pull.rebase true
git config --global diff.colorMoved zebra

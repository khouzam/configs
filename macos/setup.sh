#! /bin/bash
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

if [[ ! -d ~/.config ]] ; then
  mkdir ~/.config
fi

ln -s -f $MY_PATH/config/.inputrc ~/.inputrc
ln -s -f $MY_PATH/config/.bashrc ~/.bashrc
ln -s -f $MY_PATH/config/.bash_profile ~/.bash_profile
ln -s -f $MY_PATH/config/.bash_aliases ~/.bash_aliases
ln -s -f $MY_PATH/config/.powerlinerc ~/.powerlinerc
ln -s -f $MY_PATH/../powerline ~/.config/powerline

echo Checking and Installing Homebrew
if [[ ! -x $(command -v brew) ]] ; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    brew update
fi

echo Checking on iTerm2 installation
if [[ ! -d /Applications/iTerm.app ]]; then
    echo installing iTerm2
    brew install --cask iterm2
else
    echo iTerm2 is installed
fi

echo Checking on VSCode installation
if [[ ! -d /Applications/Visual\ Studio\ Code.app ]]; then
    echo Installing VSCode
    brew install --cask visual-studio-code
else
    echo VSCode is installed
fi

echo Checking on LastPass installation
if [[ ! -d /Applications/LastPass.app ]]; then
    echo installing Lastpass
    brew install --cask lastpass
else
    echo LastPass is installed
fi

echo Checking on LastPass CLI installation
if [[ ! -x  $(command -v lpass) ]]; then
    echo Installing lastpass-cli
    brew install lastpass-cli
else
    echo lastpass-cli is installed
fi

echo Checking and Installing Speedtest
if [[ ! -x $(command -v speedtest) ]]; then
    echo Installing Speedtest
    brew tap teamookla/speedtest
    brew update
    # Example how to remove conflicting or old versions using brew
    # brew uninstall speedtest --force
    brew install speedtest --force
else
    echo Speedtest is installed
fi


echo Checking and Installing Meld
if [[ ! -d /Applications/Meld.app ]]; then
    echo Installing Meld Diffing Tool
    brew install --cask meld
else
    echo Meld is already installed
fi

# Powerline fonts installation
echo Installing Powerline Fonts
tmp_dir=$(mktemp -d -t powerlinefonts)
pushd $tmp_dir
git clone https://github.com/powerline/fonts.git --depth=1 fonts
cd fonts
./install.sh
popd
rm -rf $tmp_dir
unset tmp_dir

echo Installing Powerline-Status
pip3 install powerline-status
pip3 install powerline-gitstatus

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

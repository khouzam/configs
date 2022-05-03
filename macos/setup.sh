#! /bin/bash
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

ln -s -f $MY_PATH/config/.inputrc ~/.inputrc
ln -s -f $MY_PATH/config/.bashrc ~/.bashrc
ln -s -f $MY_PATH/config/.bash_profile ~/.bash_profile
ln -s -f $MY_PATH/config/.bash_aliases ~/.bash_aliases
ln -s -f $MY_PATH/config/.powerlinerc ~/.powerlinerc
ln -s -f $MY_PATH/../powerline ~/.config/powerline

echo installing Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo installing iTerm2
brew install --cask iterm2

echo installing VSCode
brew install --cask visual-studio-code

echo installing Lastpass
brew install lastpass-cli
brew install --cask lastpass

echo installing Speedtest
brew tap teamookla/speedtest
brew update
# Example how to remove conflicting or old versions using brew
# brew uninstall speedtest --force
brew install speedtest --force

# Powerline installation
echo installing Powerline Fonts
mkdir -p ~/projects/powerlinefonts
cd ~/projects/powerlinefonts
git clone https://github.com/powerline/fonts.git --depth=1 fonts
cd fonts
./install.sh

pip3 install powerline-status
pip3 install powerline-gitstatus

# Configure Git
git config --global user.name "Gilles Khouzam"
git config --global user.email gilles@khouzam.com
git config --global fetch.prune true
git config --global pull.rebase true
git config --global diff.colorMoved zebra

#! /bin/bash
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

ln -s $MY_PATH/config/.inputrc ~/.inputrc
ln -s $MY_PATH/config/.bashrc ~/.bashrc
ln -s $MY_PATH/config/.bash_profile ~/.bash_profile
ln -s $MY_PATH/config/.bash_aliases ~/.bash_aliases

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

echo installing Powerline Fonts
mkdir -p ~/projects/powerlinefonts
cd ~/projects/powerlinefonts
git clone https://github.com/powerline/fonts.git --depth=1 fonts
cd fonts
./install.sh

echo installing powerline
pip3 install powerline-status
pip3 install powerline-gitstatus
POWERLINE_LOCATION="$(pip3 show powerline-status | grep Location | awk '/Location/ { print $2 }')"

# Configuring Powerline
echo # Powerline > ~/.powerlinerc
echo powerline-daemon -q >> ~/.powerlinerc
echo POWERLINE_BASH_CONTINUATION=1 >> ~/.powerlinerc
echo POWERLINE_BASH_SELECT=1 >> ~/.powerlinerc
echo source $POWERLINE_LOCATION/powerline/bindings/bash/powerline.sh >> ~/.powerlinerc

mkdir -p ~/.config/powerline
cp -r $POWERLINE_LOCATION/powerline/config_files/ ~/.config/powerline/

# Configure Git
git config --global user.name "Gilles Khouzam"
git config --global user.email gilles@khouzam.com
git config --global fetch.prune true
git config --global pull.rebase true
git config --global diff.colorMoved zebra

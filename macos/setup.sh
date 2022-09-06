#! /bin/bash
MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

brew_install() {
    echo "Installing $1 using brew"
    if brew list $1 &>/dev/null; then
        echo "$* is already installed"
    else
        brew install $* && echo "$1 is installed"
    fi
}

if [[ ! -d ~/.config ]] ; then
  mkdir ~/.config
fi

echo Checking and Installing Homebrew
if [[ ! -x $(command -v brew) ]] ; then
    # Install Homebrew
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    brew update
fi

brew_install iterm2 --cask
brew_install visual-studio-code --cask
brew_install lastpass --cask
brew_install lastpass-cli
brew_install meld --cask

echo Installing ohMyZsh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# echo Installing powerlime2k
brew_install romkatv/powerlevel10k/powerlevel10k
brew_install zsh-autosuggestions

echo Checking and Installing Speedtest
if [[ ! -x $(command -v speedtest) ]]; then
    echo Installing Speedtest
    brew tap teamookla/speedtest
    brew update
    # Example how to remove conflicting or old versions using brew
    # brew uninstall speedtest --force
    brew_install speedtest --force
else
    echo Speedtest is installed
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

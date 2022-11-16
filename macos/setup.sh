#! /bin/bash
SCRIPT_PATH=$(dirname "$0")             # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

pushd $SCRIPT_PATH

brew_install() {
    echo "Installing $1 using brew"
    if brew list $1 &>/dev/null; then
        echo "$* is already installed"
    else
        brew install $* && echo "$1 is installed"
    fi
}

run_script() {
    if [[ -f $1 ]]; then
        echo "Running $1 script"
        . $1
    fi
}

if [[ ! -d ~/.config ]] ; then
  mkdir ~/.config
fi

echo Checking and Installing Homebrew
if [[ ! -x $(command -v brew) ]]; then
    # Install Homebrew
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    brew update
fi

brew_install git-gui
brew_install sourcetree --cask
brew_install iterm2 --cask
brew_install visual-studio-code --cask
brew_install lastpass --cask
brew_install lastpass-cli
brew_install meld --cask
brew_install monitorcontrol --cask
brew_install android-platform-tools --cask
brew_install flycut --cask

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

# Run the config scripts
run_script $SCRIPT_PATH/common/scripts/linkconfigs.sh
run_script $SCRIPT_PATH/common/scripts/setgit.sh
run_script $SCRIPT_PATH/macos/scripts/setgitdiff.sh
run_script $SCRIPT_PATH/macos/scripts/sudotouchid.sh
run_script $SCRIPT_PATH/macos/scripts/setupiTerm.sh

popd

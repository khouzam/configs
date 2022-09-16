#! /bin/bash
COMMON_PATH=$(dirname "$0")/..                 # relative
COMMON_PATH=$(cd "$COMMON_PATH" && pwd)
if [[ -z "$COMMON_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

pushd $COMMON_PATH

# Link resource files
ln -s -f $COMMON_PATH/config/inputrc ~/.inputrc
ln -s -f $COMMON_PATH/config/bashrc ~/.bashrc
ln -s -f $COMMON_PATH/config/bash_profile ~/.bash_profile
ln -s -f $COMMON_PATH/config/bash_aliases ~/.bash_aliases

# ZSH configs
ln -s -f $COMMON_PATH/config/zshenv ~/.zshenv
ln -s -f $COMMON_PATH/config/zshrc ~/.zshrc
ln -s -f $COMMON_PATH/config/zsh_aliases ~/.zsh_aliases
ln -s -f $COMMON_PATH/config/p10k.zsh ~/.p10k.zsh

ln -s -f $COMMON_PATH/config/powerlinerc ~/.powerlinerc
ln -s -f $COMMON_PATH/../powerline ~/.config/powerline

popd

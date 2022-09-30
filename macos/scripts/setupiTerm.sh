#! /bin/bash
SCRIPT_PATH=$(dirname "$0")             # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

pushd $SCRIPT_PATH
GIT_ROOT=$(git root)

# Specify the preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$GIT_ROOT/macos/iTerm/settings"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Tell iTerm2 to save the prefs when quitting
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0

popd

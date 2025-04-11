#! /bin/bash

# Force function keys to be default
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Show folders on top
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true" && killall Finder

# Set Activity Monitor to network usage
defaults write com.apple.ActivityMonitor "IconType" -int "2" && killall Activity\ Monitor

# Remove "Application Downloaded from the Internet" prompt
defaults write com.apple.LaunchServices "LSQuarantine" -bool "false"

# Dock Settings
defaults write com.apple.dock "tilesize" -int "48"
defaults write com.apple.dock "largesize" -int "96" && killall Dock

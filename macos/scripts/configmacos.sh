#! /bin/bash

# Force function keys to be default
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
defaults write NSGlobalDomain AppleAccentColor -int "0"
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569 Red"

# Show folders on top
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"
defaults write com.apple.finder "FXPreferredGroupBy" -string "Name"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -int "0"
killall Finder

# Set Activity Monitor to network usage
defaults write com.apple.ActivityMonitor "IconType" -int "2" && killall Activity\ Monitor

# Remove "Application Downloaded from the Internet" prompt
defaults write com.apple.LaunchServices "LSQuarantine" -bool "false"

# Dock Settings
defaults write com.apple.dock "tilesize" -int "48"
defaults write com.apple.dock "largesize" -int "96" && killall Dock

# Setup Accent Color

#!/usr/bin/env bash

echo "Setting up Finder..."
# show hidden files
# defaults write com.apple.finder AppleShowAllFiles -bool true
# show path bar
defaults write com.apple.finder ShowPathbar -bool true
# show Finder preview pane
defaults write com.apple.finder ShowPreviewPane -bool true
# list view default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# show filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# auto-hide dock
defaults write com.apple.dock autohide -bool true
# set dock size
defaults write com.apple.dock tilesize -int 50
# restart finder
killall Finder

echo "Looking for Homebrew..."
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "/Users/$(whoami)/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

echo "Installing Oh My Zsh..."
/bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if test -f ~/Brewfile; then
    echo "Brewing apps..."
    brew bundle
fi

echo "Terminal Setup..."
TERM_NAME="OceanicMaterial"
TERM_PROFILE="~/$TERM_NAME.terminal"

if test -f "$TERM"; then
    echo "Installing terminal profile..."
    open $TERM_PROFILE
    defaults write com.apple.terminal "Default Window Settings" -string $TERM_NAME
    defaults write com.apple.Terminal "Startup Window Settings" -string $TERM_NAME
else
    echo "$TERM_PROFILE not found"
fi

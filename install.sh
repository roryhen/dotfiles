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
# prevent .DS_Store creation
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
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

echo "Looking for bun..."
if test ! $(which bun); then
  echo "Installing bun..."
  /bin/bash -c "$(curl -fsSL https://bun.sh/install)"
fi

if test -f ~/Brewfile; then
    echo "Brewing apps..."
    brew bundle
fi


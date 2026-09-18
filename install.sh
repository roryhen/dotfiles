#!/usr/bin/env bash

echo "Setting up Finder..."
# show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# show path bar
defaults write com.apple.finder ShowPathbar -bool true
# show Finder preview pane
defaults write com.apple.finder ShowPreviewPane -bool true
# list view default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# open new finder windows to the home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"
# show full path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# sort folders ahead of files
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# show filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# auto-hide dock
defaults write com.apple.dock autohide -bool true
# set dock recent apps count
defaults write com.apple.dock show-recent-count -int 5
# remove autohide delay and speed up animation
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
# prevent .DS_Store creation
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
# prevent .DS_Store creation on USB drives
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# turn off accented characters on keypress and hold
defaults write -g ApplePressAndHoldEnabled -bool false
# time after holding down a key that it starts repeating
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# speed of repeating keypresses on hold
defaults write NSGlobalDomain KeyRepeat -int 2
# disable smart quotes and dashes (invisible chars break code/shell)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# disable autocorrect
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# show scrollbars only while scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# send screenshots to ~/Downloads (png is the default)
mkdir -p "$HOME/Downloads"
defaults write com.apple.screencapture location "$HOME/Downloads"
# require password shortly after display sleep
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5
# restart finder and dock
killall Finder
killall Dock

echo "Installing Xcode..."
xcode-select --install

echo "Looking for Homebrew..."
if type brew &>/dev/null; then
  echo "Homebrew is already installed"
else
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew update

echo "Looking for Oh My Zsh..."
if test -d "$HOME/.oh-my-zsh"; then
  echo "Oh My Zsh is already installed"
  omz update
else
  echo "Installing Oh My Zsh..."
  /bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Installing powerlevel10k theme..."
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

if test -f ~/Brewfile; then
  echo "Brewing apps..."
  brew bundle --file ~/Brewfile
else
  echo "WARNING: ~/Brewfile not found, skipping brew bundle" >&2
fi

echo "Installing mise tools..."
mise install --yes

echo "Checking GitHub CLI auth..."
if ! gh auth status &>/dev/null; then
  echo "Logging in to GitHub (required for the gh credential helper)..."
  gh auth login -h github.com -w
else
  echo "GitHub CLI is already authenticated"
fi

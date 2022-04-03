#!/usr/bin/env sh

# initialkeyrepeat (int 10 = 150ms, int 1 = 15ms)
# keyrepeat (int 1 = 15ms)

# defaults write -g ApplePressAndHoldEnabled -bool false && defaults write -g InitialKeyRepeat -int 10 && defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false && defaults write -g InitialKeyRepeat -int 15 && defaults write -g KeyRepeat -int 2

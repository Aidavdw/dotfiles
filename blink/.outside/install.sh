#!/bin/bash

REPO_DIR="$HOME/read-only-repos/blink"

ln -s $REPO_DIR/target/release/blinkd ~/.local/bin/blinkd
ln -s $REPO_DIR/target/release/blinkctl ~/.local/bin/blinkctl
sudo ln -s $REPO_DIR/target/release/actived /usr/local/bin/actived
sudo cp ~/dotfiles/blink/.outside/actived.service /etc/systemd/system/actived.service

sudo systemctl enable actived --now
systemctl --user enable blinkd --now

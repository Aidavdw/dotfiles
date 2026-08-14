#!/bin/sh

export XDG_RUNTIME_DIR="/run/user/1000"
sudo mkdir -p $XDG_RUNTIME_DIR
sudo chown aida $XDG_RUNTIME_DIR
sudo chmod 700 $XDG_RUNTIME_DIR
niri --session
# TODO: clean up the dir?


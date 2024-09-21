#!/bin/bash

set -eu
printf '\n'

sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
tar -xzf tmux-3.4.tar.gz
cd tmux-3.4
./configure
make
sudo make install

#!/bin/bash

curl -L -o /tmp/pnpm-shell-competions.tar.gz https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.4/pnpm-shell-completion_x86_64-unknown-linux-musl.tar.gz
mkdir -p /tmp/pnpm-shell-completion
tar -xzf /tmp/pnpm-shell-competions.tar.gz -C /tmp/pnpm-shell-completion
pushd /tmp/pnpm-shell-completion
./install.zsh $ZSH_CUSTOM/plugins
popd

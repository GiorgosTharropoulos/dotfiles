#!/bin/bash

set -eu
printf '\n'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
UNDERLINE="$(tput smul 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
BLUE="$(tput setaf 4 2>/dev/null || printf '')"
MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

info() {
  printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"
}

warn() {
  printf '%s\n' "${YELLOW}! $*${NO_COLOR}"
}

error() {
  printf '%s\n' "${RED}x $*${NO_COLOR}" >&2
}

completed() {
  printf '%s\n' "${GREEN}✓${NO_COLOR} $*"
}

ohmyzsh_install() {
  info "Installing oh-my-zsh"
  git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  if [ -f ~/.zshrc ]; then
    info "Backup existing .zshrc"
    mv ~/.zshrc ~/.zshrc.bak
  fi
  ln -s "$PARENT_DIR/zsh/.zshrc" ~/.zshrc
  info "Changing default shell to zsh"
  sudo chsh -s $(which zsh)
  completed "oh-my-zsh installed"
}

# Install zsh suggestions
# Install zsh-syntax-highlighting
zsh_plugins_install() {
  info "Installing zsh autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  completed "Installed zsh autosuggestions"
}

fd_install() {
  info "Installing fd"
  curl -sL -o /tmp/fd-musl_10.2.0_amd64.deb https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-musl_10.2.0_amd64.deb
  sudo dpkg -i /tmp/fd-musl_10.2.0_amd64.deb
  rm /tmp/fd-musl_10.2.0_amd64.deb
  if ! fd --version | grep -q "fd 10.2.0"; then
    error "fd installation failed"
    exit 1
  fi
  completed "fd installed"
}

rg_install() {
  info "Installing ripgrep"
  curl -sL -o /tmp/ripgrep_14.1.1-1_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
  sudo dpkg -i /tmp/ripgrep_14.1.1-1_amd64.deb
  rm /tmp/ripgrep_14.1.1-1_amd64.deb
  if ! rg --version | grep -q "ripgrep 14.1.1"; then
    error "ripgrep installation failed"
    exit 1
  fi
  completed "ripgrep installed"
}

fzf_install() {
  info "Installing fzf"
  curl -sL -o /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz
  sudo tar -xvf /tmp/fzf.tar.gz -C /usr/bin
  rm /tmp/fzf.tar.gz
  sudo curl -o /usr/bin/fzf-tmux https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/bin/fzf-tmux
  sudo chmod +x /usr/bin/fzf-tmux
  completed "fzf installed"
}

zoxide_install() {
  info "Installing zoxide"
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  completed "zoxide installed"
}

p10k_install() {
  mkdir -p ~/.local/share/fonts
  curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  # fc-cache -f
  completed "MesloLGS NF installed"
  info "Installing powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  ln -s "$PARENT_DIR/zsh/.p10k.zsh" ~/.p10k.zsh
  completed "powerlevel10k installed"
}

sudo apt install -y trash-cli zsh git
ohmyzsh_install
zsh_plugins_install
fd_install
rg_install
fzf_install
zoxide_install
p10k_install

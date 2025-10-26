#!/usr/bin/env bash

set -e
set -u

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a utility if not already installed
install_if_missing() {
    local util_name="$1"
    local install_func="$2"

    if command_exists "$util_name"; then
        print_warning "$util_name is already installed. Skipping..."
        return 0
    fi

    print_status "Installing $util_name..."
    $install_func
    print_success "$util_name installed successfully!"
}

# Install zsh and oh-my-zsh
install_zsh() {
    print_status "Installing zsh, curl, git, and other dependencies..."
    sudo apt update
    sudo apt install zsh curl git wget -y

    print_status "Setting zsh as default shell..."
    sudo usermod -s "$(which zsh)" $(whoami)

    print_status "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# Install fzf
install_fzf() {
    print_status "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
    ${HOME}/.fzf/install --all
}

# Install ripgrep
install_ripgrep() {
    print_status "Installing ripgrep..."
    local ripgrep_version="15.1.0"
    local deb_file="ripgrep_${ripgrep_version}-1_amd64.deb"

    curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${ripgrep_version}/${deb_file}"
    sudo dpkg -i "$deb_file"
    rm -f "$deb_file"

    # Set up zsh completions for ripgrep
    print_status "Setting up ripgrep zsh completions..."
    mkdir -p "$HOME/.zsh-complete"
    rg --generate complete-zsh > "$HOME/.zsh-complete/_rg"
    print_status "Ripgrep completions generated. The completion path is already configured in .zshrc"
}

# Install zoxide
install_zoxide() {
    print_status "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

# Install bat
install_bat() {
    print_status "Installing bat..."
    local bat_version="0.26.0"
    local deb_file="bat_${bat_version}_amd64.deb"

    curl -LO "https://github.com/sharkdp/bat/releases/download/v${bat_version}/${deb_file}"
    sudo dpkg -i "$deb_file"
    rm -f "$deb_file"
}

# Install lazygit
install_lazygit() {
    print_status "Installing lazygit..."
    local lazygit_version="0.55.1"
    local tar_file="lazygit_${lazygit_version}_Linux_x86_64.tar.gz"

    curl -LO "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/${tar_file}"
    tar xf "$tar_file"
    sudo mv lazygit /usr/local/bin/
    rm -f "$tar_file"
    rm -rf lazygit
}

# Install nvm
install_nvm() {
    print_status "Installing nvm..."
    PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
}

# Install tmux
install_tmux() {
    print_status "Installing tmux build dependencies..."
    sudo apt update
    sudo apt install -y automake libevent-dev ncurses-dev build-essential bison pkg-config

    print_status "Cloning tmux repository..."
    git clone https://github.com/tmux/tmux.git /tmp/tmux-build
    cd /tmp/tmux-build

    print_status "Building and installing tmux..."
    sh autogen.sh
    ./configure
    make
    sudo make install

    print_status "Cleaning up build files..."
    cd /
    rm -rf /tmp/tmux-build
}

# Install tmux plugin manager (tpm)
install_tpm() {
    print_status "Installing tmux plugin manager (tpm)..."

    # Create tmux plugins directory if it doesn't exist
    mkdir -p "$HOME/.tmux/plugins"

    # Clone tpm repository
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        print_success "tpm installed successfully!"
    else
        print_warning "tpm is already installed. Skipping..."
    fi

    print_status "Note: To install tmux plugins, press prefix + I after starting tmux"
}

# Install oh-my-zsh plugins
install_oh_my_zsh_plugins() {
    print_status "Installing oh-my-zsh plugins..."

    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Create custom plugins directory if it doesn't exist
    mkdir -p "$zsh_custom/plugins"

    # Install fzf-tab
    if [ ! -d "$zsh_custom/plugins/fzf-tab" ]; then
        print_status "Installing fzf-tab plugin..."
        git clone https://github.com/Aloxaf/fzf-tab "$zsh_custom/plugins/fzf-tab"
    else
        print_warning "fzf-tab plugin already exists. Skipping..."
    fi

    # Install zsh-autosuggestions
    if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
        print_status "Installing zsh-autosuggestions plugin..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    else
        print_warning "zsh-autosuggestions plugin already exists. Skipping..."
    fi

    # Install zsh-syntax-highlighting
    if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
        print_status "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
    else
        print_warning "zsh-syntax-highlighting plugin already exists. Skipping..."
    fi

    # Install zsh-chezmoi
    if [ ! -d "$zsh_custom/plugins/zsh-chezmoi" ]; then
        print_status "Installing zsh-chezmoi plugin..."
        git clone https://github.com/mass8326/zsh-chezmoi.git $ZSH_CUSTOM/plugins/chezmoi
    else
        print_warning "zsh-chezmoi plugin already exists. Skipping..."
    fi
}

# Main installation function
main() {
    print_status "Starting unified utility installation..."
    echo "This script will install the following utilities:"
    echo "  - zsh and oh-my-zsh"
    echo "  - fzf (fuzzy finder)"
    echo "  - ripgrep (fast text search)"
    echo "  - zoxide (smart directory navigation)"
    echo "  - bat (cat clone with syntax highlighting)"
    echo "  - lazygit (simple terminal UI for git)"
    echo "  - nvm (Node Version Manager)"
    echo "  - tmux (terminal multiplexer)"
    echo "  - tmux plugin manager (tpm)"
    echo "  - oh-my-zsh plugins (fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions)"
    echo

    # Check if running non-interactively (Docker environment)
    if [ -t 0 ] && [ "$1" != "--non-interactive" ]; then
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled."
            exit 0
        fi
    else
        print_status "Running in non-interactive mode..."
    fi

    # Install zsh and oh-my-zsh first (required for plugins)
    install_if_missing "zsh" install_zsh

    # Wait a bit for oh-my-zsh to be fully set up
    sleep 2

    # Install other utilities
    install_if_missing "fzf" install_fzf
    install_if_missing "rg" install_ripgrep
    install_if_missing "zoxide" install_zoxide
    install_if_missing "bat" install_bat
    install_if_missing "lazygit" install_lazygit
    install_if_missing "nvm" install_nvm
    install_if_missing "tmux" install_tmux
    install_if_missing "tmux" install_tpm

    # Install oh-my-zsh plugins (only if oh-my-zsh is installed)
    if [ -d "$HOME/.oh-my-zsh" ]; then
        install_oh_my_zsh_plugins
    else
        print_warning "oh-my-zsh not found. Skipping plugin installation."
    fi

    echo
    print_success "All utilities have been installed successfully!"
    print_status "Please restart your terminal or run 'source $HOME/.zshrc' to apply changes."

    # Reminder about updating .zshrc
    echo
    print_warning "Reminder: Make sure your $HOME/.zshrc file includes the installed plugins:"
    echo "  plugins=(git fzf fzf-tab zsh-autosuggestions zsh-syntax-highlighting zsh-completions)"
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
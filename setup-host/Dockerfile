FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies and create user
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with sudo access
RUN useradd -m -s /bin/zsh appuser && \
    echo "appuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set working directory
WORKDIR /work

# Copy dotfiles and scripts
COPY . .

# Change ownership of all files to appuser
RUN chown -R appuser:appuser /work

# Switch to non-root user
USER appuser
WORKDIR /home/appuser

# Make the install script executable and run it
RUN chmod +x /work/setup.sh && \
    /work/setup.sh --non-interactive

# Copy custom .zshrc after oh-my-zsh is installed
RUN cp /work/dot_zshrc /home/appuser/.zshrc && \
    chmod 644 /home/appuser/.zshrc

RUN mkdir -p /home/appuser/.config/ \
    && cp -r /work/dot_config/* /home/appuser/.config/

# Set zsh as the default shell for the container
SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/bin/zsh"]

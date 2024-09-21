FROM ubuntu:22.04 as builder

# Build arguments for UID and GID
ARG UID
ARG GID

# Update and install basic packages
RUN apt update && apt install -y \
    build-essential curl wget \
    sudo

# Create a non-root user and group
RUN groupadd -g ${GID} appgroup && \
    useradd -m -u ${UID} -g appgroup -s /bin/bash bootstrap && \
    echo "bootstrap ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER bootstrap

WORKDIR /home/bootstrap
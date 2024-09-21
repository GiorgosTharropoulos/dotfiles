#!/bin/bash

# Define the jq binary path
JQ_PATH="/opt/jq/bin/jq"

# Check if jq exists and remove it if it does
if [ -f "$JQ_PATH" ]; then
  sudo rm "$JQ_PATH"
fi

# Create the directory if it does not exist
if [ ! -d "/opt/jq/bin" ]; then
  sudo mkdir -p "/opt/jq/bin"
fi

# Download jq binary
curl -L -o /tmp/jq https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64

# Move the binary to the desired location
sudo mv /tmp/jq "$JQ_PATH"

# Make the binary executable
sudo chmod +x "$JQ_PATH"

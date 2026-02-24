#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 username"
  exit 1
fi

USER_NAME="$1"
PUBKEY_FILE="$(cd "$(dirname "$0")" && pwd)/../keys/web01_id_rsa.pub"

if [ ! -f "$PUBKEY_FILE" ]; then
  echo "Public key not found"
  exit 1
fi

sudo adduser --disabled-password --gecos "" "$USER_NAME"

HOME_DIR=$(eval echo "~$USER_NAME")
sudo mkdir -p "$HOME_DIR/.ssh"
sudo cp "$PUBKEY_FILE" "$HOME_DIR/.ssh/authorized_keys"
sudo chmod 700 "$HOME_DIR/.ssh"
sudo chmod 600 "$HOME_DIR/.ssh/authorized_keys"
sudo chown -R "$USER_NAME:$USER_NAME" "$HOME_DIR/.ssh"

sudo systemctl restart ssh || sudo systemctl restart sshd

echo "User created with passwordless ssh"

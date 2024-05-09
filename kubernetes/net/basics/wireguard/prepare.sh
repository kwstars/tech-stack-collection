#/bin/bash

# Install WireGuard
sudo apt update && sudo apt install wireguard-tools -y
wg genkey >gw1-private
wg genkey >gw2-private
wg pubkey <gw1-private >gw1-public
wg pubkey <gw2-private >gw2-public

# Build Image
docker build -t my-wireguard .

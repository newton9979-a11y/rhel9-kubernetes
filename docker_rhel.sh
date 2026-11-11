
#!/bin/bash

# =====================================================
# Docker + Git Installation Script for RHEL 9
# =====================================================

set -euo pipefail

echo "=========================================="
echo " Docker and Git Installation - RHEL 9"
echo "=========================================="

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script using sudo."
    exit 1
fi

# Check RHEL version
if ! grep -qE '^ID="?rhel"?$' /etc/os-release ||
   ! grep -qE '^VERSION_ID="?9([.]|")' /etc/os-release; then
    echo "ERROR: This script is intended for RHEL 9."
    exit 1
fi

# Identify original login user
TARGET_USER="${SUDO_USER:-}"

if [[ -z "$TARGET_USER" || "$TARGET_USER" == "root" ]]; then
    echo "Enter the non-root username for Docker group access:"
    read -r TARGET_USER
fi

if ! id "$TARGET_USER" >/dev/null 2>&1; then
    echo "ERROR: User $TARGET_USER does not exist."
    exit 1
fi

echo "[1/7] Updating system packages..."
dnf -y update

echo "[2/7] Removing conflicting packages..."
dnf remove -y \
    docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    podman \
    runc || true

echo "[3/7] Installing required utilities..."
dnf -y install dnf-plugins-core git curl

echo "[4/7] Adding official Docker repository..."
dnf config-manager --add-repo \
    https://download.docker.com/linux/rhel/docker-ce.repo

echo "[5/7] Installing Docker Engine and plugins..."
dnf -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "[6/7] Enabling and starting Docker..."
systemctl enable --now docker

echo "[7/7] Configuring Docker group..."
groupadd -f docker
usermod -aG docker "$TARGET_USER"

echo
echo "=========================================="
echo " Installation Completed Successfully!"
echo "=========================================="

echo "Docker Version:"
docker --version

echo "Docker Compose Version:"
docker compose version

echo "Git Version:"
git --version

echo
echo "Docker Service Status:"
systemctl is-active docker

echo
echo "User added to Docker group: $TARGET_USER"

echo
echo "IMPORTANT:"
echo "Log out and log in again, or run:"
echo "newgrp docker"
echo
echo "Then verify Docker using:"
echo "docker run hello-world"
echo
echo "Installation completed."

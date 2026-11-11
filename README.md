# Docker & Kubernetes Installation – RHEL 9

## 1. Project Structure

```text
rhel9-kubernetes/
│
├── README.md
│
└── scripts/
    ├── install-docker-git-rhel9.sh
    └── init-cluster.sh
```

## 2. Clone GitHub Repository

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>

cd rhel9-kubernetes
```

## 3. Set Script Permissions

```bash
chmod +x scripts/install-docker-git-rhel9.sh

chmod +x scripts/init-cluster.sh
```

## 4. Install Docker and Git

Execute the installation script using sudo privileges.

```bash
sudo ./scripts/install-docker-git-rhel9.sh
```

Activate Docker group permissions:

```bash
newgrp docker
```

## 5. Verify Docker Installation

```bash
# Docker version
docker --version

# Docker Compose version
docker compose version

# Git version
git --version

# Docker service status
sudo systemctl status docker

# Docker information
docker info

# Test Docker container
docker run hello-world

# Check Docker group
groups
```

## 6. Install kubectl and Kind

Install kubectl:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl
```

Install Kind:

```bash
mkdir -p ~/.local/bin

curl -Lo ~/.local/bin/kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64

chmod +x ~/.local/bin/kind

export PATH="$HOME/.local/bin:$PATH"

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

## 7. Verify kubectl and Kind

```bash
kubectl version --client

kind version
```

## 8. Create Kubernetes Cluster

Execute the initialization script as a normal user with Docker group access (do not use sudo).

```bash
./scripts/init-cluster.sh
```

Default cluster configuration:

- Cluster Name: cka-practice
- Kind Version: v0.31.0
- Kubernetes Version: v1.35.1

Recreate the cluster:

```bash
./scripts/init-cluster.sh --recreate
```

## 9. Verify Kubernetes Cluster

```bash
# Cluster information
kubectl cluster-info

# Check nodes
kubectl get nodes -o wide

# Check namespaces
kubectl get namespaces

# Check all pods
kubectl get pods -A

# Check system pods
kubectl get pods -n kube-system

# Check current context
kubectl config current-context

# Check Kind clusters
kind get clusters
```

Expected context:

```text
kind-cka-practice
```

## 10. Delete Kubernetes Cluster

```bash
kind delete cluster --name cka-practice
```

## 11. Troubleshooting

### Docker permission denied

```bash
sudo usermod -aG docker $USER

newgrp docker

docker ps
```

### Docker service not running

```bash
sudo systemctl enable --now docker

sudo systemctl status docker
```

### Kind command not found

```bash
export PATH="$HOME/.local/bin:$PATH"

kind version
```

---

## Installation Summary

| Component | Verification |
|---|---|
| Docker | `docker --version` |
| Docker Compose | `docker compose version` |
| Git | `git --version` |
| Docker Service | `sudo systemctl status docker` |
| kubectl | `kubectl version --client` |
| Kind | `kind version` |
| Kubernetes Nodes | `kubectl get nodes` |
| Kubernetes Pods | `kubectl get pods -A` |

**Important:** Use `sudo` for Docker installation and system-level package operations. Run Kind and kubectl as your normal user after Docker group permissions are activated.

**Practice Motto:** Slow is smooth, smooth is fast.

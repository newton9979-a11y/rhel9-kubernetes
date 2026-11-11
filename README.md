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

```bash
sudo ./scripts/install-docker-git-rhel9.sh
```

Activate Docker group permissions:

```bash
newgrp docker
```

## 5. Verify Docker Installation

```bash
docker --version
docker compose version
git --version
sudo systemctl status docker
docker info
docker run hello-world
groups
```

## 6. Create Kubernetes Cluster

Run the initialization script as a normal user (without sudo).

```bash
./scripts/init-cluster.sh
```

Default configuration:

- Cluster Name: cka-practice
- Kind Version: v0.31.0
- Kubernetes Version: v1.35.1

Recreate cluster:

```bash
./scripts/init-cluster.sh --recreate
```

## 7. Verify Kubernetes Cluster

```bash
kubectl cluster-info

kubectl get nodes -o wide

kubectl get namespaces

kubectl get pods -A

kubectl get pods -n kube-system

kubectl config current-context

kind get clusters
```

Expected context:

```text
kind-cka-practice
```

## 8. Delete Kubernetes Cluster

```bash
kind delete cluster --name cka-practice
```

## 9. Troubleshooting

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
| Kubernetes Nodes | `kubectl get nodes` |
| Kubernetes Pods | `kubectl get pods -A` |
| Kind | `kind version` |

**Important:** Use sudo for Docker installation and system-level operations. Run Kind and kubectl as your normal user after Docker permissions are activated.

**Practice Motto:** Slow is smooth, smooth is fast.

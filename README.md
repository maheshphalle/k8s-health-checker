````markdown
# Kubernetes Cluster Health Checker

**Author:** Mahesh Phalle  
**Date:** July 2025  

---

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Architecture & Components](#architecture--components)  
3. [Prerequisites](#prerequisites)  
4. [Directory Structure](#directory-structure)  
5. [Installation & Setup](#installation--setup)  
6. [Usage](#usage)  
7. [Configuration & Customization](#configuration--customization)  
8. [Screenshots](#screenshots)  
9. [Troubleshooting](#troubleshooting)  
10. [Contributing](#contributing)  
11. [License](#license)  

---

## Project Overview

This **Kubernetes Cluster Health Checker** automates deployment of a demo application, monitors node and pod health, and self‑heals by restarting any pods that enter a crash loop. It’s designed to be simple enough for Kubernetes newcomers, yet flexible via environment variables.

---

## Architecture & Components

- **Demo App** (`scripts/kubernetes/base/`):  
  A basic `nginx` Deployment + Service to simulate an application running in your cluster.  

- **Monitoring Rules** (`scripts/kubernetes/monitoring/`):  
  A Prometheus alert rule that fires when a pod restarts more than twice in 5 minutes.

- **Health‑Check Script** (`scripts/check-health.sh`):  
  A Bash script that:
  1. Waits for all nodes to become `Ready`.  
  2. Lists any pods with restart counts > 0.  
  3. Deletes (restarts) those pods to self‑heal.

- **Beginner Guide** (`Beginner Guide.md`):  
  Step‑by‑step instructions for setting up the environment, running the health checker, and capturing screenshots.

---

## Prerequisites

Install these tools on your local machine:

- **Git**  
- **Docker** (with Desktop or Engine)  
- **Minikube** (for local K8s cluster)  
- **kubectl** (Kubernetes CLI)  

> On macOS:  
> ```bash
> brew install git docker kubectl minikube
> ```  
> On Ubuntu/Debian:  
> ```bash
> sudo apt update
> sudo apt install git docker.io kubectl
> curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
> sudo dpkg -i minikube_latest_amd64.deb
> ```

---

## Directory Structure

````

k8s-health-checker/
├── README.md
├── Beginner Guide.md
├── scripts/
│   ├── check-health.sh
│   └── kubernetes/
│       ├── base/
│       │   ├── deployment.yaml
│       │   └── service.yaml
│       └── monitoring/
│           └── alert.yaml
└── screenshots/
├── 01-minikube-status.png
├── 02-deploy.png
└── 03-health-check.png

````

---

## Installation & Setup

1. **Clone the repository**  
   ```bash
   git clone https://github.com/maheshphalle/k8s-health-checker.git
   cd k8s-health-checker
````

2. **Initialize & configure Git (if not already)**

   ```bash
   git init
   git remote add origin https://github.com/maheshphalle/k8s-health-checker.git
   git branch -M main
   ```

3. **Ensure script is executable**

   ```bash
   chmod +x scripts/check-health.sh
   ```

---

## Usage

1. **Start your local cluster**

   ```bash
   minikube start
   ```

2. **Deploy the demo application**

   ```bash
   kubectl apply -f scripts/kubernetes/base/
   ```

3. **Apply the Prometheus alert rule**

   ```bash
   kubectl apply -f scripts/kubernetes/monitoring/
   ```

4. **Run the health‑check & self‑heal script**

   ```bash
   ./scripts/check-health.sh
   ```

   You will see:

   ```
   === Kubernetes Health Checker by Mahesh Phalle ===
   Start time: 2025-07-13 14:23:45
   Waiting up to 60s for all nodes Ready...
   ✅ All nodes are Ready.
   Checking for pod restarts...
   ✅ No crashed pods found.
   ```

---

## Configuration & Customization

The script supports two environment variables:

* `NODE_TIMEOUT` (default `60s`):
  How long to wait for all nodes to become Ready.

* `POD_RESTART_THRESHOLD` (default `0`):
  Minimum restart count to trigger a pod restart.

Example:

```bash
export NODE_TIMEOUT=120s
export POD_RESTART_THRESHOLD=1
./scripts/check-health.sh
```

---

## Screenshots

Store your captures in the `screenshots/` folder:

| Filename                 | Description                                  |
| ------------------------ | -------------------------------------------- |
| `01-minikube-status.png` | Output of `minikube status`                  |
| `02-deploy.png`          | Output of `kubectl apply` for base manifests |
| `03-health-check.png`    | Script run showing self‑heal logic           |

---

## Troubleshooting

* **`kubectl` not found**: Ensure you installed `kubectl` and it’s on your `PATH`.
* **Minikube start errors**: Verify virtualization is enabled (e.g., Docker Desktop or Hypervisor).
* **Script failures**: Run with `bash -x scripts/check-health.sh` to debug line by line.

---

## Contributing

This is a personal learning project. Feel free to fork and enhance, but please credit the original author (Mahesh Phalle).

---

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT).

````

You can copy this into your `README.md`, save, commit, and push:

```bash
git add README.md
git commit -m "docs: add detailed README"
git push origin main
````

# swe645-hw2
## Peter Shin (G01073633)

## What I Built

A static student survey web form for "Totally Real University", containerized with Docker, deployed on a Kubernetes cluster managed via Rancher on AWS EC2, and continuously delivered via a Jenkins CI/CD pipeline.

## Architecture

- `index.html` — Bootstrap 5 dark-themed single-page form with no backend; submission is client-side only
- `Dockerfile` — Ubuntu 24.04 base, installs nginx, serves `index.html` on port 80
- `buildImage.sh` — CLI interface to build, tag, and push the Docker image to Docker Hub (`frozenmandu/swe645-hw2`)
- `Jenkinsfile` — CI/CD pipeline: Checkout → Build → Push → Deploy → Cleanup
- `kubernetes/deployment.yaml` — Kubernetes Deployment with 3 replicas
- `kubernetes/service.yaml` — NodePort Service exposing the app externally

## Prerequisites

- Docker
- kubectl configured to point at your cluster
- Jenkins with the following plugins: Git, Docker Pipeline, Workspace Cleanup, Pipeline Stage View
- A Docker Hub account with a personal access token (PAT)
- An AWS EC2 instance running a Rancher-managed Kubernetes cluster

## Local Development

### Environment Variables

Create a `.env` file in the project root (already gitignored):
```
export DOCKER_USER=<your-dockerhub-username>
export DOCKER_PASS=<your-dockerhub-pat>
```

Load the variables before running the build script:
```bash
source .env
```

### Build Script Usage

```
./buildImage.sh [-b] [-t <tag>] [-p] [-l] [-h]

  -b        Build the Docker image
  -t <tag>  Tag to apply (default: latest)
  -p        Push the image to Docker Hub
  -l        Login to Docker Hub using DOCKER_USER and DOCKER_PASS
  -h        Show help
```

**Build and run locally:**
```bash
./buildImage.sh -b
docker run -p 8081:80 frozenmandu/swe645-hw2:latest
```
Then open `http://localhost:8081` in your browser.

**Build, login, and push:**
```bash
source .env
./buildImage.sh -b -l -p -t <tag>
```

## Kubernetes Deployment

The app runs on a Kubernetes cluster managed via Rancher, hosted on AWS EC2.

**Deploy manually:**
```bash
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```

**Check status:**
```bash
kubectl get pods
kubectl get service hw2
```

The service is type `NodePort` — access the app at `http://<EC2-public-IP>:<NodePort>`.

### EC2 Security Group Inbound Rules

| Port | Purpose |
|------|---------|
| 22 | SSH |
| 8080 | Jenkins web UI |
| 30000–32767 | Kubernetes NodePort range |

## CI/CD Pipeline

The Jenkins pipeline triggers automatically on every push to `main` via a GitHub webhook.

### Pipeline Stages

| Stage | Description |
|-------|-------------|
| Checkout | Clones the repo from GitHub |
| Build | Builds the Docker image tagged with `$BUILD_NUMBER` using the Docker Pipeline plugin |
| Push to Docker Hub | Pushes the image to Docker Hub using the `dockerhub-creds` Jenkins credential |
| Deploy | Runs `kubectl set image` to update the Kubernetes deployment in-place (skippable via `DEPLOY` parameter) |
| Cleanup | Removes the local Docker image from the EC2 to prevent disk buildup |

### Jenkins Setup

1. Install plugins: Git, Docker Pipeline, Workspace Cleanup, Pipeline Stage View
2. Add credentials:
   - **ID:** `dockerhub-creds` — Kind: Username with password (Docker Hub username + PAT)
   - **ID:** `kubeconfig-id` — Kind: Secret file (your cluster's kubeconfig)
3. Add the `jenkins` user to the `docker` group: `sudo usermod -aG docker jenkins`
4. Create a Pipeline job pointing to this repo's `Jenkinsfile`
5. Configure a GitHub webhook pointing to `http://<EC2-public-IP>:8080/github-webhook/`

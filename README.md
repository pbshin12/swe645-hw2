# swe645-hw2
## Peter Shin (G01073633)

## What I Built

A static student survey web form for "Totally Real University", containerized with Docker and served via nginx. The form collects personal information, campus feedback, referral source, likelihood to recommend, raffle entries, and additional comments.

## How It Works

- `index.html` is a Bootstrap 5 dark-themed single-page form with no backend — submission is client-side only
- nginx serves the file from `/var/www/html` inside an Ubuntu-based Docker container on port 80
- `buildImage.sh` provides a CLI interface to build, tag, and push the image to Docker Hub (`frozenmandu/swe645-hw2`)

## Installation & Setup

### Prerequisites
- Docker
- A Docker Hub account with a personal access token (PAT)

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

## CI/CD Pipeline

> Not yet implemented.

The pipeline will use Jenkins to automate building and pushing the Docker image on each commit. The `BUILD_NUMBER` environment variable will be passed as the image tag via `-t ${BUILD_NUMBER}`, and Docker Hub credentials will be injected using Jenkins' `credentials()` binding.

## Kubernetes Deployment

> Not yet implemented.

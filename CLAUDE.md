# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

Build and tag the Docker image:
```bash
bash buildImage.sh
```

Run the container locally:
```bash
docker run -p 80:80 frozenmandu/swe645-hw2:latest
```

Push to Docker Hub:
```bash
docker push frozenmandu/swe645-hw2:latest
```

For Jenkins CI, pass `$BUILD_NUMBER` as the tag — the build script is intended to accept it as an argument so each build gets a unique tag (e.g., `frozenmandu/swe645-hw2:42`).

## Architecture

This is a static single-page HTML form (`index.html`) served by nginx inside a Docker container.

- **`index.html`** — Bootstrap 5 dark-themed student survey form (no backend; form submission is client-side only)
- **`Dockerfile`** — Ubuntu base, installs nginx, copies `index.html` to `/var/www/html`, exposes port 80
- **`buildImage.sh`** — builds and tags the image as `frozenmandu/swe645-hw2` on Docker Hub

There is no build pipeline, package manager, or server-side code — changes to `index.html` only require rebuilding and pushing the Docker image.

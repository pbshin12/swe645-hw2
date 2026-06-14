#!/bin/bash
# Shell script to build the container and tag them

DOCKER_FILE="./Dockerfile"
BUILD=false
TAG="latest"
PUSH=false
LOGIN=false

# Note to self: export these env vars for publishing images and for Jenkins to inject PATs inside them
# DOCKER_USER
# DOCKER_PASS
# full build/publish command: ./buildImage.sh -blp -t test

help() {
    echo "Usage: $0 [-b] [-t <tag>] [-p] [-l]"
    echo "  -b        Build the Docker image"
    echo "  -t <tag>  Tag to apply (default: latest)"
    echo "  -p        Push the image onto registry"
    echo "  -l        Login to Docker Hub using DOCKER_USER and DOCKER_PASS env vars"
    echo "  -h        Show this help message"
}

login() {
    echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
}

build() {
    local tag=$1
    docker build -t frozenmandu/swe645-hw2:${tag} -f ${DOCKER_FILE} .
}

push() {
    local tag=$1
    docker push frozenmandu/swe645-hw2:${tag}
}

while getopts "bt:plh" opt; do
    case $opt in
        b) 
            BUILD=true 
            ;;
        t) 
            TAG="$OPTARG"
            ;;
        p)
            PUSH=true
            ;;
        l)
            LOGIN=true
            ;;
        h)
            help
            exit 1
            ;;
        *) 
            help
            exit 1
            ;;
    esac
done

if [ "$BUILD" = true ]; then
    build "$TAG"
else
    help
    exit 1
fi

if [ "$LOGIN" = true ]; then
    login
fi

if [ "$PUSH" = true ]; then
    push "$TAG"
fi
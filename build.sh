#!/bin/sh
PUSH=$1

DOCKER_REPO=supertypo/kaspa-explorer

BUILD_DIR="$(dirname $0)"
REPO_URL="https://github.com/supertypo/kaspa-explorer.git"
REPO_DIR="$BUILD_DIR/work/kaspa-explorer"

set -e

if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL" "$REPO_DIR"
  echo $(cd "$REPO_DIR" && git reset --hard HEAD~1)
fi

tag=$(cd "$REPO_DIR" && git log -n1 --format="%cs.%h")

if $(cd "$REPO_DIR" && git pull | grep -qv "up to date"); then
  tag=$(cd "$REPO_DIR" && git log -n1 --format="%cs.%h")
  echo
  echo "Git repo changed, building tag '$tag'."
  echo

  docker build --pull --build-arg REPO_DIR="$REPO_DIR" -t $DOCKER_REPO:$tag "$BUILD_DIR"
  docker tag $DOCKER_REPO:$tag $DOCKER_REPO:latest
  echo Tagged $DOCKER_REPO:latest
else
  echo "Git repo is still at '$tag', skipping build."
fi

if [ "$PUSH" = "push" ]; then
  docker push $DOCKER_REPO:$tag
  docker push $DOCKER_REPO:latest
fi


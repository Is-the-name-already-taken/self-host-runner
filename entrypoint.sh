#!/bin/bash
set -e

export CONTAINER_HOST=unix:///run/user/${HOST_UID}/podman/podman.sock

cd actions-runner
./config.sh --url https://github.com/${ORGANIZATION} --token ${TOKEN} --name "${RUNNER_NAME}"
exec ./run.sh
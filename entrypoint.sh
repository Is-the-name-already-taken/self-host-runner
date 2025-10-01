#!/bin/bash
set -e

cd actions-runner
./config.sh --url https://github.com/${ORGANIZATION} --token ${TOKEN} --name "${RUNNER_NAME}"
exec ./run.sh
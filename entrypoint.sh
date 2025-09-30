#!/bin/bash
set -e

cd actions-runner
./config.sh --url https://github.com/${ORGANIZATION} --token ${TOKEN}
exec ./run.sh
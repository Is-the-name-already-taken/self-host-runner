#!/bin/bash
set -e

./config.sh --url https://github.com/${ORGANIZATION} --token ${TOKEN}
exec ./run.sh
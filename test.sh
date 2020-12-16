#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( ! $# ))

[[ -n "$DOCKER_TAG" ]]
[[ "$DOCKER_TAG" = native ]] || exit 0

/usr/local/bin/entrypoint &
P="$!"
sleep 99
kill "$P"
wait -n "$P"


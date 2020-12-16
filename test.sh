#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( ! $# ))
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" || : # max prio

/usr/local/bin/entrypoint &
P="$!"
sleep 99
kill "$P"
wait -n "$P"


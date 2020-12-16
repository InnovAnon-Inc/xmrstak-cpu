#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( ! $# ))
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" || : # max prio

if [[ "$COIN" = neoscrypt ]] ; then
  ARGS=
else
  ARGS=--randomize
fi
/usr/local/bin/cpuminer $ARGS -c "/conf.d/$1.json" &
P="$!"
sleep 99
kill "$P"
wait -n "$P"


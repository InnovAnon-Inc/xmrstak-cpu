#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( $# == 1 ))
[[ -f "/conf.d/$1.json" ]]
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" # max prio
sudo -u nobody -g nogroup -- \
/usr/local/bin/cpuminer --randomize -c "/conf.d/$1.json"


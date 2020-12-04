#! /bin/sh
set -eux

ssh -F /run/secrets/config lmaddox "$(basename "$0")"


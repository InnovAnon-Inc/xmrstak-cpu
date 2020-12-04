#! /usr/bin/env bash
set -euxo pipefail                                    # catch some errors implicitly
(( $UID ))                                            # check your privilege
renice -n +19 "$$"                                    # be nice

exit 2 # TODO need to get service names

RSCRIPT="$(readlink -f "$0")"                         # self-reflection

PROJECT="$(basename "$(readlink -f "$PWD")")"         # is run from project dir

#  if (( ! $# )) ; then                                # no args
#  PROJECT="$(basename "$(readlink -f "$PWD")")"       # => is run from project dir
#elif ((   $# )) ; then                                # args
#  PROJECT="$1"                                        # => arg    is project dir
#  shift
#  cd "$(dirname "$RSCRIPT")/$PROJECT"                 #    change to project dir
#else exit 1 ; fi                                      # invalid usage

COMPOSE=("docker-compose.y*ml")                       # is a docker-compose project ?
(( ${#COMPOSE[@]} == 1 ))
COMPOSE="${COMPOSE[0]}"
[[ -e "$COMPOSE" ]]

MOUNTPT="$1"
shift

trap 'docker rm helper' 0
docker run -v "${PROJECT}_${PROJECT}":"$MOUNTPT" \
  --name helper busybox true
for k in $@ ; do
  docker cp "$k" helper:"$MOUNTPT/$k"
done


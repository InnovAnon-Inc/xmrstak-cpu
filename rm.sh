#! /usr/bin/env bash
set -euxo pipefail                                    # catch some errors implicitly
(( $UID ))                                            # check your privilege
renice -n +19 "$$"                                    # be nice

exit 2 # TODO need to get service names

RSCRIPT="$(readlink -f "$0")"                         # self-reflection

  if (( ! $#    )) ; then                             # 0 args
  PROJECT="$(basename "$(readlink -f "$PWD")")"       # => is run from project dir
elif (( $# == 1 )) ; then                             # 1 arg
  PROJECT="$1"                                        # => arg    is project dir
  cd "$(dirname "$RSCRIPT")/$PROJECT"                 #    change to project dir
else exit 1 ; fi                                      # invalid usage

COMPOSE=(docker-compose.y*ml)                         # is a docker-compose project ?
(( ${#COMPOSE[@]} == 1 ))
COMPOSE="${COMPOSE[0]}"
[[ -e "$COMPOSE" ]]

docker service rm "${PROJECT}_${PROJECT}"


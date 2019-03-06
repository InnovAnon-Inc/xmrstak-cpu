#! /bin/bash
set -exo nounset

[ $# -eq 2 ] || exit 1
T="`sed 's#/$##' <<< "$1"`"
P=$2

trap "sudo docker rmi -f $T" 0

./systemctl.sh $T
sudo docker run -p $P -ti $T /bin/sh

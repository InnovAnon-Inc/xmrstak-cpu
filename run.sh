#! /bin/bash
set -exo nounset

[ $# -eq 1 ] || exit 1
#[ $# -ge 1 ] || exit 1
#[ -f $1/port -o $# -eq 2 ] || exit 1
T="`sed 's#/$##' <<< "$1"`"
#if [ -f $1/port ] ; then
	P="`cat $1/port`"
#else
#	P=$2
#fi
I="`cat $1/ip`"

trap "sudo docker rmi -f $T" 0

./create-network.sh

./systemctl.sh $T
#sudo docker run \
#	--net mynet123 \
#	--ip $I \
#	--hostname $T.mynet123.com \

sudo docker run \
	-p $P:$P \
	-ti \
	$T
#	$T /bin/sh
#sudo docker run --publish-all=true -ti $T /bin/sh
#sudo docker run -Pti $T /bin/sh

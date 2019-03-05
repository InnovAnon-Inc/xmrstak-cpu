#! /bin/bash
set -exo nounset

sudo docker images | \
awk 'NR>1 {print $3}' | \
xargs -L1 \
	sudo docker rmi -f

sudo docker images

#! /bin/bash
set -exo nounset

docker images | \
awk 'NR>1 {print $3}' | \
xargs -L1 \
	docker rmi -f

docker images

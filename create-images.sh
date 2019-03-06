#! /bin/bash
set -exo nounset

./create-network.sh

find . -mindepth 1 -maxdepth 1 -type d -exec basename '{}' \; | \
xargs -L1 \
	./systemctl.sh

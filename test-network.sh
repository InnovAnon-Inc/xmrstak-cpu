#! /bin/bash
set -exo nounset

PORTS="`find . -mindepth 2 -maxdepth 2 -name port -exec \
	cat '{}' + | \
	tr \\\n \ | \
	sed 's/ $//'`"

GREP_PORTS="`sed 's/ /\\\|/g' <<< "$PORTS"`"

NMAP_PORTS="`sed 's/ /,/g' <<< "$PORTS"`"

sudo netstat -tupln | grep -e "$GREP_PORTS"
sudo nmap -p "$NMAP_PORTS" localhost


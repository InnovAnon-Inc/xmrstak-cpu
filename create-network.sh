#! /bin/bash
set -exo nounset

[ ! -z "`sudo docker network list | awk '$2 == "mynet123" {print $2}'`" ] || \
sudo docker network create --subnet=172.18.0.0/16 mynet123


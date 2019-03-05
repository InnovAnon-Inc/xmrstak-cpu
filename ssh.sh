#! /bin/bash
set -exo nounset

[ ! -f ~/.ssh/id_rsa.pub ] || exit 2
[ ! -f ~/.ssh/id_rsa     ] || exit 3

ssh-keygen -b 4096 -t rsa -N ''

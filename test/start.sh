#! /bin/sh
set -exo nounset

netcat -kl 0.0.0.0 1000
#netcat -kl localhost 1000

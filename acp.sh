#! /bin/bash
set -exo nounset

[ $# -ne 0 ] || exit 1

git add . || :
git commit -m "$*"
git push origin master

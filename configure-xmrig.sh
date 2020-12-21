#! /bin/bash
#! /usr/bin/env bash
set -euxo pipefail
(( UID ))
[[ -n "$DOCKER_TAG" ]]
case "$DOCKER_TAG" in
  generic)
      ;;
  ppc7450)
      CFLAGS="$CFLAGS -mcpu=$DOCKER_TAG"
      ;;
  *)
      CFLAGS="$CFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG"
      ;;
esac

#  CFLAGS="$CFLAGS"           \
#CXXFLAGS="$CXXFLAGS $CFLAGS" \
export   CFLAGS="$CFLAGS"
export CXXFLAGS="$CXXFLAGS $CFLAGS"
cmake .. "$@"


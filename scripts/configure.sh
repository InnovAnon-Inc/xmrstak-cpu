#! /bin/bash
#! /usr/bin/env bash
set -euxo pipefail
(( UID ))
(( ! $# ))
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

# shellcheck disable=SC2086
./configure --with-curl ${CONF}           \
CXXFLAGS="$CXXFLAGS -std=gnu++11 $CFLAGS" \
  CFLAGS="$CFLAGS"


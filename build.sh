#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))
(( $UID ))

CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"

for ARCH in nehalem nocona sandybridge core2 ; do
  ARCH="$ARCH"         \
  docker-compose build \
    --build-arg "CFLAGS=-march=${ARCH} -mtune=${ARCH} ${CFLAGS}"
done

ARCH=ppc7450
ARCH="$ARCH"         \
docker-compose build \
  --build-arg "CFLAGS=-mcpu=${ARCH} ${CFLAGS}"


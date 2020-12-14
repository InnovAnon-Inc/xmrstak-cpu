#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))
(( $UID ))
for DOCKER_TAG in nehalem nocona sandybridge core2 ppc7450 ; do
  DOCKER_TAG="$DOCKER_TAG"         \
  docker-compose build \
    --build-arg CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
done


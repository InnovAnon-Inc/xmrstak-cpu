#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))
(( $UID ))
#for DOCKER_TAG in nehalem nocona sandybridge core2 ppc7450 ; do
#for DOCKER_TAG in 7450 ; do
#for DOCKER_TAG in nehalem nocona sandybridge core2 ; do
for DOCKER_TAG in nehalem ; do
  DOCKER_TAG="$DOCKER_TAG"               \
  docker-compose build --pull --parallel \
    --build-arg DOCKER_TAG="$DOCKER_TAG" \
    --build-arg CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
done


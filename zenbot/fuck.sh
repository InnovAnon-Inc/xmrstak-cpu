#! /usr/bin/env bash
set -euxo pipefail                                    # catch some errors implicitly
(( $UID ))                                            # check your privilege
renice -n +19 "$$"                                    # be nice

docker service rm zenbot_server zenbot_mongodb zenbot_adminmongo

COMPOSE=docker-compose.yml
awk '$1 == "image:" {print $2}' "$COMPOSE" |          # for each image name
xargs -L1 docker pull                                 # pull latest (presumably)

. .env

[[ -n "$ZENBOT_DEFAULT_SELECTOR" ]]
[[ -n "$ZENBOT_POLONIEX_API_KEY" ]]
[[ -n "$ZENBOT_POLONIEX_SECRET" ]]
[[ -n "$ZENBOT_KRAKEN_API_KEY" ]]
[[ -n "$ZENBOT_KRAKEN_SECRET" ]]
[[ -n "$ZENBOT_KRAKEN_TOS_AGREE" ]]
[[ -n "$ZENBOT_BITTREX_API_KEY" ]]
[[ -n "$ZENBOT_BITTREX_SECRET" ]]
[[ -n "$ZENBOT_BITSTAMP_API_KEY" ]]
[[ -n "$ZENBOT_BITSTAMP_SECRET" ]]
[[ -n "$ZENBOT_BITSTAMP_CLIENT_ID" ]]
[[ -n "$ZENBOT_CEXIO_CLIENT_ID" ]]
[[ -n "$ZENBOT_CEXIO_API_KEY" ]]
[[ -n "$ZENBOT_CEXIO_SECRET" ]]
[[ -n "$ZENBOT_GEMINI_API_KEY" ]]
[[ -n "$ZENBOT_GEMINI_SECRET" ]]

docker stack deploy        \
    --with-registry-auth   \
    -c "$COMPOSE"          \
    zenbot                                            # deploy to swarm

docker ps |
grep zenbot


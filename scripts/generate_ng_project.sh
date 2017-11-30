#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Generate a new Angular project
# Date:
#   9/30/2017

set -ex

# set environment variables
source $(pwd)/scripts/envVariables

[[ $# -gt 0 ]] || (echo "No options" && exit $ERR_OPERATOR)

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -n|--name)
    NAME="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "ERROR: unknown options"
    exit $ERR_OPERATOR
    ;;
  esac
done
echo "ready to generate a new Angular project"

docker run \
  --rm \
  -v $PWD:$APP_DIR \
  $DOCKER_ACCOUNT_NAME/$DOCKER_IMG_TAG_NG_CLI:$DOCKER_IMG_NG_CLI_VERSION \
  ng new $NAME

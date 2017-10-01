#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   ...
# Date:
#   9/30/2017

# set environment variables
source $(pwd)/scripts/envVariables

[[ $# -gt 0 ]] || (echo "No options" && exit 1)

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
      exit 1
      ;;
  esac
done
echo "continue"
docker run \
  --rm \
  -v $PWD:$APP_DIR \
  $DOCKER_ACCOUNT_NAME/$DOCKER_IMG_TAG_NG_CLI:$DOCKER_IMG_VERSION \
  ng new $NAME
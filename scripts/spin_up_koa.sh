#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Spin up the Koa application and manage the application by pm2
# Date:
#   9/30/2017

set -ex

# set environment variables
source $(pwd)/scripts/envVariables

[[ $# -gt 0 ]] || (echo "No options" && exit 1)
NAME="unknown"
MODE="dev"
BUILD_OPTIONS=""
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -app|--application)
    NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--mode)
    MODE="$2"
    # check whether mode is supported
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "ERROR: unknown options"
    exit 1
    ;;
  esac
done
echo "check whether the container which runs koa app is up"
echo "if the container is not running, spin it up. otherwise create a new container"

inspection=$(docker inspect $KOA_APP_NAME)
if [[ $inspection == "[]" ]]; then
  echo "container not exist and a new one will be spinned up"
else
  echo "container already exists; it's going to be removed and a new one will be created"
  docker rm -f $KOA_APP_NAME
fi

# spin up koa app
commands_for_spinning_up_koa=(
  "npm install && "
  "pm2 start app.js --node-args=\"--harmony\" && "
  "pm2 show app"
)

# generate bundle files
docker run \
  --rm \
  -v $PWD:$APP_DIR $DOCKER_ACCOUNT_NAME/$DOCKER_IMG_TAG_NG_CLI:$DOCKER_IMG_NG_CLI_VERSION \
  sh -c "ng build $BUILD_OPTIONS" && \

# spin up container
docker run \
  --name $KOA_APP_NAME
  -v $PWD/koa_app:$APP_DIR \
  -v $PWD/pipeline/dist:$APP_DIR/dist \
  -p 8080:8080 \
  $DOCKER_ACCOUNT_NAME/$DOCKER_IMG_TAG_KOA:$DOCKER_IMG_KOA_VERSION \
  sh -c "${commands_for_spinning_up_koa[*]}"

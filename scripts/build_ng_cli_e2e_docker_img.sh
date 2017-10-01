#!/bin/bash
#
# Author:
#   Alan Tai
# Program:
#   Build docker image of e2e testing of Angular app
# Date:
#   9/30/2017

# set environment variables
source $(pwd)/scripts/envVariables

#############################################################
# Create docker mage and spin up container running Go server
# Globals:
#   None
# Arguments:
#   DOCKER_NAME_GO_SERVER
#   DOCKER_IMG_VERSION_GO_SERVER
# Returns:
#   None
#############################################################
# text styles
bold=$(tput bold)
normal=$(tput sgr0)

docker build \
  -t $DOCKER_ACCOUNT_NAME/$DOCKER_IMG_TAG_NG_CLI_E2E:$DOCKER_IMG_NG_CLI_VERSION \
  --build-arg NG_CLI_VERSION=$NG_CLI_VERSION \
  --build-arg USER_HOME_DIR=$USER_HOME_DIR \
  --build-arg APP_DIR=$APP_DIR \
  --build-arg USER_ID=$USER_ID \
  --build-arg NPM_CONFIG_LOGLEVEL=$NPM_CONFIG_LOGLEVEL \
  --build-arg USER_HOME_DIR=$USER_HOME_DIR \
  -f $(pwd)/docker_files/Dockerfile.ng-cli-e2e .

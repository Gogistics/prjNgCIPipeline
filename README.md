# CI Pipeline for Angular Development

Prerequistes:

1. understand what devops should do for development cross multiple teams

2. get all infrastructures ready:

    2-1. version control

    2-2. docker registry

    2-3. package hosts, such as Debian package host, or artifactory (optional)

    2-4. Angular development environment

    2-5. etc. (depends on what development and teams need)


Tasks of establishing the pipeline:

1. initialize git repository

2. create docker files

3. write automation scripts:

    3-1. start from creating the docker image of ng-cli and push it to docker registry

    3-2. create the docker image of unit testing and push it to docker registry

    3-3. create the docker image of e2e testing and push it to docker registry


```shell=
# DevOps
# These steps are done by DevOps:

# 1. login docker registry
$ docker login docker-registry.gogistics-tw.com
or with user name and password
$ docker login -u <username> -p <password> docker-registry.gogistics-tw.com

# 2. create docker image by running scripts and then tag the docker image which is created and tested successfully. The commands below demo how to generate the docker image of ng-cli

# 2-1. create the docker image of ng-cli
$ ./scripts/build_ng_cli_docker_img.sh

# 2-2. tag the docker image of ng-cli
$ docker tag atai/ng-cli:v1 docker-registry.gogistics-tw.com/atai/ng-cli:v1

# 3. push the docker image of ng-cli to the docker registry
$ docker push docker-registry.gogistics-tw.com/atai/ng-cli:v1
```


```shell=
# Development

# pull the image of ng-cli from docker registry
$ docker pull docker-registry.gogistics-tw.com/atai/ng-cli:v1

# clone source code from git repository and switch to the project directory
$ git clone <ng-project-repo-url> # for example, git clone git@bitbucket.org:gogistics-tw/ngclipipeline.git
$ cd <ng-project-dir> # in this demo, <ng-project-dir> is ngclipipeline/pipeline


# Unit test the code and then generate the bundle files

# unit testing
$ docker run --rm -v "$PWD":/ng_app docker-registry.gogistics-tw.com/atai/ng-cli-karma:v1 ng test --single-run

# e2e testing
$ docker run --rm -v "$PWD":/ng_app docker-registry.gogistics-tw.com/atai/ng-cli-e2e:v1 ng e2e

# once developers build features and want to generate bundle files, run the command below
$ docker run --rm -v "$PWD":/ng_app docker-registry.gogistics-tw.com/atai/ng-cli:v1 ng build (-prod) (-aot)

Note: if you encounter the build issue, **Node Sass could not find a binding for your current environment**, run change command to:

$ docker run --rm -v "$PWD":/ng_app docker-registry.gogistics-tw.com/atai/ng-cli-e2e:v1 sh -c 'npm rebuild node-sass --force && ng build (-prod) (-aot)'

# check size of folders
$ du -h dist/
```


**References:**

Trion-

[Trion Development](https://github.com/trion-development)

[Docker Build Container for Angular CLI](https://www.trion.de/news/2017/01/20/docker-build-angular-cli.html)

[Docker File for Angular CLI](https://www.trion.de/news/2017/02/25/dockerfile-fuer-angular-cli.html)

Docker-

[How To Set Up a Private Docker Registry on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04)

[Adding Self-signed Registry Certs to Docker & Docker for Mac](http://container-solutions.com/adding-self-signed-registry-certs-docker-mac/)

[docker login](https://docs.docker.com/engine/reference/commandline/login/#usage)

[docker push](https://docs.docker.com/engine/reference/commandline/push/)

[docker pull](https://docs.docker.com/engine/reference/commandline/pull/)

Headless Chromium-

[Headless Chromium](https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md)

[addyosmani/headless.md](https://gist.github.com/addyosmani/5336747)

Init System-

[dumb-init](https://github.com/Yelp/dumb-init)

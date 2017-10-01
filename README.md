# CI Pipeline for Angular Development

Prerequistes:
1. understand what devops should do for development cross multiple teams
2. get all infrastructure ready
  2-1. version control
  2-2. docker registry
  2-3. package host (such as Debian package host) or artifactory
  2-6. Angular development environment
  2-5. etc. (depends on what development and teams need)

Tasks:
1. initialize git repository
2. create docker files
3. write automation scripts
  3-1. start from creating the docker image of ng-cli and push docker registry
  3-2. create the docker image of unit testing
  3-3. create the docker image of e2e testing


```sh
# These steps should be done by DevOps:

# 1. login docker registry
$ docker login docker-registry.gogistics-tw.com

# 2. tag the docker image just created and tested successfully
$ docker tag atai/ng-cli:v1 docker-registry.gogistics-tw.com/atai/ng-cli:v1

# 3. push to docker registry
$ docker push docker-registry.gogistics-tw.com/atai/ng-cli:v1

```

```sh
# Ready for development

# pull image from docker registry
$ docker pull docker-registry.gogistics-tw.com/atai/ng-cli:v1

# clone source code from git repository and start to develop Angular applications
$ git clone <ng-project-repo-url>
$ cd <ng-project-dir>
```

```sh
# unit testing
$ docker run --rm -v "$PWD":/ng_app atai/ng-cli-karma:v1 ng test --single-run

# e2e testing
$ docker run --rm -v "$PWD":/ng_app atai/ng-cli-e2e:v1 ng e2e

# once developers build features and want to generate bundle files, run the command below
$ docker run --rm -v "$PWD":/ng_app docker-registry.gogistics-tw.com/atai/ng-cli:v1 ng build (-prod) (-aot)

# check size of folders
$ du -h dist/
```


References:
[Adding Self-signed Registry Certs to Docker & Docker for Mac](http://container-solutions.com/adding-self-signed-registry-certs-docker-mac/)
[dumb-init](https://github.com/Yelp/dumb-init)
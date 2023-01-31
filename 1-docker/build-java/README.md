# Java builder

Example for Java-application: Docker-builder & Docker-runner (& Makefile)

## Development 

### BUILD Application (by docker)

* `make builder-shell` - run shell inside BUILDER docker-container
* `make build` - compile App by BUILDER docker-container
* `make docker` - make App docker-image
* `make docker_clean` - clean docker-stuff

### RUN Application

* `make run` - run App in RUNNER docker-container (`make build` must be run first)
* `make run_docker` - run App docker-image
* `make images` - list docker-images of this App

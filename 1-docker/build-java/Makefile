.ONESHELL:
.PHONY: builder-shell build docker images run run_docker

PROJECT_NAME=build-java
BRANCH := $(shell git rev-parse --abbrev-ref HEAD | sed -e 's/-/./g;s=/=.=g')
COMMIT := $(shell git rev-parse --short HEAD)
BUILDER_IMAGE=openjdk:11-jdk-slim
BUILDER_CMD=javac -d . src/test_java.java
RUNNER_IMAGE=amazoncorretto:17
RUNNER_CMD=sh -c "time java -classpath . bin.test_java"

builder-shell:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_IMAGE) sh

build:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_IMAGE) $(BUILDER_CMD) \
	&& ls -al bin/

docker:
	docker build -t $(PROJECT_NAME):$(BRANCH) --progress plain \
		-f Dockerfile .
	docker images | grep $(PROJECT_NAME)

clean:
	docker container prune -f ; docker image prune -f ; docker volume prune -f

list-images:
	docker images | grep $(PROJECT_NAME)

run:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(RUNNER_IMAGE) $(RUNNER_CMD)

run_docker:
	docker run -it --rm -u `id -u`:`id -g` \
		$(PROJECT_NAME):$(BRANCH)

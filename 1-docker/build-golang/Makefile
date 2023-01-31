.ONESHELL:
.PHONY: build docker download fmt-check run

PROJECT_NAME=build-golang
BRANCH := $(shell git rev-parse --abbrev-ref HEAD | sed -e 's/-/./g;s=/=.=g')
COMMIT := $(shell git rev-parse --short HEAD)
APP_BIN=./app.bin.local
BUILDER_IMAGE=golang:1.17
BUILDER_CMD=go build -v -o $(APP_BIN) src/main.go
#BUILDER_PARAMS=-e GOPROXY="http://proxy.internal:3000" -e GOPRIVATE="*.local,*.internal" -e GOSUMDB="off"
BUILDER_PARAMS=
LINTER_IMAGE=golangci/golangci-lint:v1.30
RUNNER_IMAGE=debian:11
RUNNER_CMD=bash -c "time ./$(APP_BIN)"

builder-shell:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_PARAMS) \
		$(BUILDER_IMAGE) bash

lint:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_PARAMS) \
		$(LINTER_IMAGE) golangci-lint run -v

fmt-check:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_IMAGE) gofmt -d ./

fmt:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_IMAGE) gofmt -w ./

download:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_PARAMS) \
		$(BUILDER_IMAGE) go mod download -x

build:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(BUILDER_PARAMS) \
		-e CGO_CPPFLAGS="-I/usr/include" \
 		-e CGO_LDFLAGS="-L/usr/lib -lpthread -lrt -lstdc++ -lm -lc -lgcc" \
 		-e CC="/usr/bin/gcc" \
 		-e CFLAGS="-march=x86-64" \
 		-e PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" \
 		-e CGO_ENABLED=0 \
 		-e GOOS=linux \
 		-e GOARCH=amd64 \
 		$(BUILDER_IMAGE) $(BUILDER_CMD) \
	&& chmod u+x ./app.* && ls -al app.*

docker:
	docker build -t $(PROJECT_NAME):$(BRANCH) --progress plain \
		--build-arg CI_JOB_TOKEN=$(CI_JOB_TOKEN) \
		-f Dockerfile .
	docker images | grep $(PROJECT_NAME)

docker-alpine:
	docker build -t $(PROJECT_NAME):$(BRANCH) --progress plain \
		--build-arg CI_JOB_TOKEN=$(CI_JOB_TOKEN) \
		-f Dockerfile.alpine .
	docker images | grep $(PROJECT_NAME)

clean:
	docker container prune -f ; docker image prune -f ; docker volume prune -f
	rm -rf .cache $(APP_BIN)

list-images:
	docker images | grep $(PROJECT_NAME)

run:
	docker run -it --rm -u `id -u`:`id -g` -v `pwd`:/mnt -w /mnt \
		-e HOME="/mnt" \
		$(RUNNER_IMAGE) $(RUNNER_CMD)

run_docker:
	docker run -it --rm -u `id -u`:`id -g` \
		$(PROJECT_NAME):$(BRANCH)

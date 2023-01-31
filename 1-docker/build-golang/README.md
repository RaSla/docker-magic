# Golang builder

Example for Golang-application: Docker-builder & Docker-runner (& Makefile)

## Development

### BUILD Application (by docker)

* `make builder-shell` - run shell inside BUILDER docker-container
* `make download` - download go-modules as needed
* `make fmt-check` - check sources by `gofmt -d ./`
* `make fmt` - fix sources by `gofmt -w ./`
* `make build` - compile binary
* `CI_JOB_TOKEN=<__YOUR_PRIVATE_GITLAB_TOKEN__> make docker` - make docker-image
* `make lint` - lint by `golangci-lint run -v` (docker-image)

### RUN Application

* `go run ./src/main.go` - local run (golang is required)
* `./app.bin.local` - run binary (compile binary FIRST, by `make build`)
* `make run` - run App in RUNNER docker-container (compile binary FIRST, by `make build`)
* `make list-images` - list docker-images of this App

### CLEAN

* `make clean` - clean docker-stuff; delete GO-cache & `app.bin.local`

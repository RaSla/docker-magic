FROM golang:1.17 AS build

ARG GOPROXY=""
ARG GOPRIVATE="*.local,*.internal"
ARG GOSUMDB="off"

WORKDIR /src

# dependencies caching
# COPY ./go.mod .
# COPY ./go.sum .
# ARG CI_JOB_TOKEN
# RUN git config --global url."https://gitlab-ci-token:$CI_JOB_TOKEN@gitlab.rasla.ru".insteadOf https://gitlab.rasla.ru
# RUN go mod download

COPY . .

# Setup the compilation environment
ENV CGO_CPPFLAGS="-I/usr/include"
ENV CGO_LDFLAGS="-L/usr/lib -lpthread -lrt -lstdc++ -lm -lc -lgcc"
ENV CC="/usr/bin/gcc"
ENV CFLAGS="-march=x86-64"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN go build -v -o /go/bin/app ./src/main.go

FROM gcr.io/distroless/static-debian11
# ARG http_proxy="http://proxy.local:8080"
# ARG https_proxy="http://proxy.local:8080"

LABEL architecture=amd64
LABEL name=build-golang
LABEL version=release-1.0.1

WORKDIR /
COPY --from=build /go/bin/app /bin/test_go

ENTRYPOINT ["/bin/test_go"]

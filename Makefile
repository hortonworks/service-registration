BINARY=service-registration

VERSION=0.8
BUILD_TIME=$(shell date +%FT%T)
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME} -X main.App=${BINARY}"
GOFILES_NOVENDOR = $(shell find . -type f -name '*.go' -not -path "./vendor/*")

deps:
	go get github.com/keyki/glu
	go get github.com/tools/godep

format:
	gofmt -w ${GOFILES_NOVENDOR}

vet:
	go vet -race github.com/hortonworks/cloudbreak-service-registration

build: format vet build-darwin build-linux

build-darwin:
	GOOS=darwin CGO_ENABLED=0 go build -a -installsuffix cgo ${LDFLAGS} -o build/Darwin/${BINARY} main.go

build-linux:
	GOOS=linux CGO_ENABLED=0 go build -a -installsuffix cgo ${LDFLAGS} -o build/Linux/${BINARY} main.go

release: build
	rm -rf release
	glu release

.DEFAULT_GOAL := build

.PHONY: build

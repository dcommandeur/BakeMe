# syntax=docker/dockerfile:1

ARG GO_VERSION="1.23"
ARG GOLANGCI_LINT_VERSION="1.61"

# base downloads the necessary Go modules
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS base

WORKDIR /src

RUN --mount=src=go.mod,dst=go.mod \
	--mount=src=go.sum,dst=go.sum \
	--mount=type=cache,target=/go/pkg/mod \
	go mod download

# build compiles the program
FROM base AS build

ARG TARGETOS TARGETARCH

ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH

RUN --mount=target=. \
	--mount=type=cache,target=/go/pkg/mod \
	go build -o "/usr/bin/bakeme" .
	
# test runs the tests
FROM base AS test

# *** TIP: The --mount=type=cache directive caches Go modules between builds, improving 
# build performance by avoiding the need to re-download dependencies. This shared cache 
# ensures that the same dependency set is available across build, test, and other stages. ***
RUN --mount=target=. \
	--mount=type=cache,target=/go/pkg/mod \
	go test .

# lint runs the linter
FROM golangci/golangci-lint:v${GOLANGCI_LINT_VERSION}-alpine AS lint

# *** TIP: Because this stage relies on executing an external dependency, it's generally 
# a good idea to define the version you want to use as a build argument. This lets you 
# more easily manage version upgrades in the future by collocating dependency versions 
# to the beginning of the Dockerfile. ***
RUN --mount=target=.,rw \
    golangci-lint run

# image creates a runtime image
FROM alpine AS image

COPY --from=build "/usr/bin/bakeme" "/usr/bin/bakeme".

ENTRYPOINT ["/usr/bin/bakeme"]

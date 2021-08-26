FROM golang:1.16 AS builder

# Set necessary environment variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

# Copy the code into the container
COPY . .

# Build the application
RUN make build

# Build a small image
FROM alpine:latest

RUN apk add --no-cache bash

COPY --from=builder /build/tmp/hw04_istio /
EXPOSE 8080

# Command to run
ENTRYPOINT ["/hw04_istio"]
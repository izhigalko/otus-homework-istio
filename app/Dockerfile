#---Build stage---
FROM --platform=linux/amd64 golang:1.19 AS builder
COPY . /go/src/
WORKDIR /go/src

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags='-w -s' -o /go/bin/service

#---Final stage---
FROM --platform=linux/amd64 alpine:latest
COPY --from=builder /go/bin/service /go/bin/service
CMD /go/bin/service --port 8090 --host '0.0.0.0'
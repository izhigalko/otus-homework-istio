FROM golang:1.19.4-buster as build

ENV BIN_FILE "/opt/health/health"
ENV CODE_DIR "/go/src/"

WORKDIR ${CODE_DIR}
COPY . ${CODE_DIR}

ARG LDFLAGS
RUN CGO_ENABLED=0 go build -ldflags "$LDFLAGS" -o ${BIN_FILE} app/main.go

FROM scratch

LABEL SERVICE="health"
LABEL MAINTAINERS="astrviktor@gmail.com"

COPY --from=build /opt/health/health /srv/health

WORKDIR /srv
ENTRYPOINT ["/srv/health"]

FROM golang:alpine AS build

ENV \
        CGO_ENABLED=0 \
	WEBHOOK_VERSION=2.8.1

WORKDIR /src/
RUN \
    echo "*** install build packages ***" && \
    apk add --no-cache curl tar git unzip && \
    echo "*** Build webhook ***" && \
        cd /src && \
        git clone https://github.com/adnanh/webhook.git && \
        cd webhook && \
        git checkout ${WEBHOOK_VERSION} && \
        go build -o /usr/local/bin/webhook

FROM lsiobase/alpine:3.18

ENV \
        HOOK_SECRET= \
        HOOK_ARGS= \
	TZ=UTC

WORKDIR /tmp

COPY root /
COPY --from=build /usr/local/bin/webhook /usr/local/bin/webhook

EXPOSE 9000

VOLUME [ "/config" ]

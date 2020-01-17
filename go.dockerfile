FROM golang:1.13-alpine

ENV PROTOBUF_VERSION='3.11.2'
ENV PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-all-${PROTOBUF_VERSION}.tar.gz"

WORKDIR /go/src/

RUN apk --no-cache update \
    && apk add --no-cache git \
    # REPL
    && go get github.com/motemen/gore/cmd/gore \
    # Completion on gore and highlight on gore
    && go get github.com/mdempsky/gocode \
    && go get github.com/k0kubun/pp \
    # Add all golang default packages
    && go get golang.org/x/tools/cmd/... \
    # Linter
    && go get golang.org/x/lint/golint \
    # Hot reload
    && go get github.com/oxequa/realize \
    # Gorilla mux
    && go get github.com/gorilla/mux \
    # Gin-Gonic
    && go get github.com/gin-gonic/gin \
    # MySQL driver
    && go get github.com/go-sql-driver/mysql \
    # Postgres driver
    && go get github.com/lib/pq \
    # gRPC
    # https://grpc.io/docs/quickstart/go/
    && go get google.golang.org/grpc \
    && go get github.com/golang/protobuf/protoc-gen-go \
    && wget ${PROTOBUF_URL} \
    && tar -C /usr/local/bin -xzf protobuf-all-${PROTOBUF_VERSION}.tar.gz \
    && mv /usr/local/bin/protobuf-${PROTOBUF_VERSION} /usr/local/bin/protobuf \
    && rm protobuf-all-${PROTOBUF_VERSION}.tar.gz

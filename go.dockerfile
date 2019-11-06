FROM golang:1.13-alpine

ARG GITHUB_USER_NAME
ENV GITHUB_USER_NAME $GITHUB_USER_NAME

WORKDIR /go/src/github.com/${GITHUB_USER_NAME}

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
    && go get github.com/go-sql-driver/mysql

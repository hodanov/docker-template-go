FROM golang:1.16.2

ARG POSTGRES_DB
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_PORT
ARG POSTGRES_SERVER
ENV POSTGRES_DB $POSTGRES_DB
ENV POSTGRES_USER $POSTGRES_USER
ENV POSTGRES_PASSWORD $POSTGRES_PASSWORD
ENV POSTGRES_PORT $POSTGRES_PORT
ENV POSTGRES_SERVER $POSTGRES_SERVER

WORKDIR /go/src/

RUN apt-get update \
    # Get all golang default packages
    && go get golang.org/x/tools/cmd/... \
    # Get debugging tools
    && go get golang.org/x/tools/gopls \
    && go get github.com/go-delve/delve/cmd/dlv \
    # MySQL driver
    && go get github.com/go-sql-driver/mysql \
    # Postgres driver
    && go get github.com/lib/pq

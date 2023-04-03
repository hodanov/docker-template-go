FROM golang:1.20.2-alpine3.17

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

RUN apk add --no-cache git build-base tzdata \
    # Get debugging tools
    && go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest
    # MySQL driver
    # && go install github.com/go-sql-driver/mysql@latest \
    # Postgres driver
    # && go install github.com/lib/pq@latest

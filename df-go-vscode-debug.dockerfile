FROM golang:1

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common setup script - SHA generated on release
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl ca-certificates 2>&1 \
    && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && ([ "${COMMON_SCRIPT_SHA}" = "dev-mode" ] || (echo "${COMMON_SCRIPT_SHA} /tmp/common-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install Go tools
ARG GO_TOOLS_WITH_MODULES="\
    golang.org/x/tools/gopls \
    honnef.co/go/tools/... \
    golang.org/x/tools/cmd/gorename \
    golang.org/x/tools/cmd/goimports \
    golang.org/x/tools/cmd/guru \
    golang.org/x/lint/golint \
    github.com/mdempsky/gocode \
    github.com/cweill/gotests/... \
    github.com/haya14busa/goplay/cmd/goplay \
    github.com/sqs/goreturns \
    github.com/josharian/impl \
    github.com/davidrjenni/reftools/cmd/fillstruct \
    github.com/uudashr/gopkgs/v2/cmd/gopkgs \
    github.com/ramya-rao-a/go-outline \
    github.com/acroca/go-symbols \
    github.com/godoctor/godoctor \
    github.com/rogpeppe/godef \
    github.com/zmb3/gogetdoc \
    github.com/fatih/gomodifytags \
    github.com/mgechev/revive \
    github.com/go-delve/delve/cmd/dlv"
RUN mkdir -p /tmp/gotools \
    && cd /tmp/gotools \
    && export GOPATH=/tmp/gotools \
    # Go tools w/module support
    && export GO111MODULE=on \
    && (echo "${GO_TOOLS_WITH_MODULES}" | xargs -n 1 go get -x )2>&1 \
    # gocode-gomod
    && export GO111MODULE=auto \
    && go get -x -d github.com/stamblerre/gocode 2>&1 \
    && go build -o gocode-gomod github.com/stamblerre/gocode \
    # golangci-lint
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin 2>&1 \
    # Move Go tools into path and clean up
    && mv /tmp/gotools/bin/* /usr/local/bin/ \
    && mv gocode-gomod /usr/local/bin/ \
    && rm -rf /tmp/gotools

# Update this to "on" or "off" as appropriate
ENV GO111MODULE=auto

#-------------------------------------------------------------------------------------------------------------

ENV PROTOBUF_VERSION='3.11.2'
ENV PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-all-${PROTOBUF_VERSION}.tar.gz"

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
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git openssh-client less iproute2 procps lsb-release \
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
    # semaphore
    && go get golang.org/x/sync/semaphore \
    # gRPC
    # https://grpc.io/docs/quickstart/go/
    && go get google.golang.org/grpc \
    && go get github.com/golang/protobuf/protoc-gen-go \
    && wget ${PROTOBUF_URL} \
    && tar -C /usr/local/bin -xzf protobuf-all-${PROTOBUF_VERSION}.tar.gz \
    && mv /usr/local/bin/protobuf-${PROTOBUF_VERSION} /usr/local/bin/protobuf \
    && rm protobuf-all-${PROTOBUF_VERSION}.tar.gz

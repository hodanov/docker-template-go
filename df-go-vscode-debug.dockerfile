FROM golang:1

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install git openssh-client less iproute2 procps lsb-release \
    && mkdir -p /tmp/gotools \
    && cd /tmp/gotools \
    && GOPATH=/tmp/gotools GO111MODULE=on go get -v golang.org/x/tools/gopls@latest 2>&1 \
    && GOPATH=/tmp/gotools GO111MODULE=on go get -v \
        honnef.co/go/tools/...@latest \
        golang.org/x/tools/cmd/gorename@latest \
        golang.org/x/tools/cmd/goimports@latest \
        golang.org/x/tools/cmd/guru@latest \
        golang.org/x/lint/golint@latest \
        github.com/mdempsky/gocode@latest \
        github.com/cweill/gotests/...@latest \
        github.com/haya14busa/goplay/cmd/goplay@latest \
        github.com/sqs/goreturns@latest \
        github.com/josharian/impl@latest \
        github.com/davidrjenni/reftools/cmd/fillstruct@latest \
        github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest  \
        github.com/ramya-rao-a/go-outline@latest  \
        github.com/acroca/go-symbols@latest  \
        github.com/godoctor/godoctor@latest  \
        github.com/rogpeppe/godef@latest  \
        github.com/zmb3/gogetdoc@latest \
        github.com/fatih/gomodifytags@latest  \
        github.com/mgechev/revive@latest  \
        github.com/go-delve/delve/cmd/dlv@latest 2>&1 \
    #
    # Build Go tools w/o module support
    && GOPATH=/tmp/gotools go get -v github.com/alecthomas/gometalinter 2>&1 \
    #
    # Build gocode-gomod
    && GOPATH=/tmp/gotools go get -x -d github.com/stamblerre/gocode 2>&1 \
    && GOPATH=/tmp/gotools go build -o gocode-gomod github.com/stamblerre/gocode \
    #
    # Install Go tools
    && mv /tmp/gotools/bin/* /usr/local/bin/ \
    && mv gocode-gomod /usr/local/bin/ \
    #
    # Install golangci-lint
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin 2>&1 \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/gotools

# Update this to "on" or "off" as appropriate
ENV GO111MODULE=auto

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

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

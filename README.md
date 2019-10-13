# The Golang Dev Environment

This is the Golang dev-environment.

The environment is using the following technologies:

- Golang: 1.13-alpine
- gore...REPL
- golint...linter
- realize...hot reload
- gorilla mux...router
- gin-gonic...web framework

## Requirements

This requires the following to run:

- Docker
- Docker Compose

## Getting Started

1. Clone the repo.

```
git clone git@github.com:hodanov/docker-template-golang.git
```

The directory structure is the below.

```
.
├── .env
├── README.md
├── docker-compose.yml
└── go.dockerfile
```

2. After cloning, modify the `GITHUB_USER_NAME` in `.env` file.  

3. Execute `docker-compose up`

```
docker-compose up -d
```

Docker container will run and the `code/` directory will be made.

The directory is mounted `/go/src/github.com/${GITHUB_USER_NAME}/` directory in a container.

Thank you.

## Author

[Hoda](https://hodalog.com)

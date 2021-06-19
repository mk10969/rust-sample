#### variable list #####
SHELL=/usr/bin/env bash -o pipefail

APP_NAME=rust-app
APP_VERSION=v0.1.0

#### command list #####
help:  ## Makefile usage
	@echo "command         description"
	@echo "--------------------------------------------------------------------"
	@grep -E '^[0-9a-zA-Z_/-]+[[:blank:]]*:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[1;32m%-15s\033[0m %s\n", $$1, $$2}'

build:  ## docker build
	docker build -t ${APP_NAME}:${APP_VERSION} .

run:  ## docker run
	docker run -d --rm ${APP_NAME}:${APP_VERSION} | xargs docker logs -f
	# docker run -d --rm ${APP_NAME}:${APP_VERSION}

down:  ## docker down
	docker ps | grep "${APP_NAME}:${APP_VERSION}" | cut -d ' ' -f 1 | xargs docker rm -f

#
# github.com/monitoror/monitoror
#

DEFAULT: build

MAKEFLAGS = --silent

# ============= TESTS =============
.PHONY: test
test: test-unit ## run tests

.PHONY: test-unit
test-unit: ## run unit tests, to change the output format use: GOTESTSUM_FORMAT=(dots|short|standard-quiet|short-verbose|standard-verbose) make test-unit
	@./scripts/test/test-unit

.PHONY: test-coverage
test-coverage: ## run test coverage
	@./scripts/test/test-coverage

.PHONY: test-coverage-html
test-coverage-html: ## run test coverage and generate cover.html
	@./scripts/test/test-coverage-html

# ============= LINT =============
.PHONY: lint
lint: ## run linter
	@./scripts/lint

# ============= MOCKS =============
.PHONY: mock
mock: mock-monitorable mock-pkg

.PHONY: mock-monitorable
mock-monitorable: ## generate mocks of monitorable sub-directories
	@./scripts/mock/mock-monitorable

.PHONY: mock-pkg
mock-pkg: ## generate mocks of pkg directory listed in scripts/mock/mock-pkg
	@./scripts/mock/mock-pkg

# ============= BUILDS =============
.PHONY: build
build: ## build executable for current environment
	@./scripts/build/rice
	@./scripts/build/build

.PHONY: build-cross
build-cross: ## build all executables
	@./scripts/build/rice
	@./scripts/build/build linux/amd64
	@./scripts/build/build linux/ARMv5
	@./scripts/build/build windows
	@./scripts/build/build macos

.PHONY: build-linux-amd64
build-linux-amd64: ## build executable for Linux
	@./scripts/build/rice
	@./scripts/build/build linux/amd64

.PHONY: build-linux-ARMv5
build-linux-ARMv5: ## build executable for Raspberry Pi (ARM V5)
	@./scripts/build/rice
	@./scripts/build/build linux/ARMv5

.PHONY: build-windows
build-windows: ## build executable for Windows
	@./scripts/build/rice
	@./scripts/build/build windows

.PHONY: build-macos
build-macos: ## build executable for MacOs
	@./scripts/build/rice
	@./scripts/build/build macos

.PHONY: build-docker
build-docker: build-linux-amd64 ## build docker image based on linux/amd64 binariy
	@./scripts/build/docker

# ============= BUILDS FAKER (for demo) =============

.PHONY: build-faker
build-faker: ## build faker executable for current environment
	@./scripts/build/rice
	@./scripts/build/faker

# ============= RUN =============
.PHONY: run
run: ## run monitoror
	@./scripts/run/run

.PHONY: run-faker
run-faker: ## run monitoror in faker mode
	@./scripts/run/faker

# ============= VERSION =============
.PHONY: version
version: ## bump version of monitoror
	@./scripts/version/bump

# ============= TOOLING =============
.PHONY: clean
clean: ## remove build artifacts
	rm -rf ./binaries/*

.PHONY: install
install: ## installing tools / dependencies
	@./scripts/install

.PHONY: help
help: ## print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {gsub("\\\\n",sprintf("\n%22c",""), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: fmt
fmt:
	go fmt ./...

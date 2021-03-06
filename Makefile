BUILD := build
GO ?= go
GOFILES := $(shell find . -name "*.go" -type f ! -path "./vendor/*")
GOFMT ?= gofmt
GOIMPORTS ?= goimports -local=github.com/jacksontj/promxy

.PHONY: clean
clean:
	$(GO) clean -i ./...
	rm -rf $(BUILD)

.PHONY: fmt
fmt:
	$(GOFMT) -w -s $(GOFILES)

.PHONY: imports
imports:
	$(GOIMPORTS) -w $(GOFILES)

.PHONY: test
test:
	$(GO) test -v ./...

.PHONY: release
release:
	./build.bash github.com/jacksontj/promxy/cmd/promxy $(BUILD)
	./build.bash github.com/jacksontj/promxy/cmd/remote_write_exporter $(BUILD)

testlocal-build:
	docker build -t 127.0.0.1:32000/promxy:latest .
	docker push 127.0.0.1:32000/promxy:latest

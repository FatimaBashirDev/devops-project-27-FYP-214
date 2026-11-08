OUT_DIR := out
SRC_DIR := src
SOURCES := $(wildcard $(SRC_DIR)/*.md)
PAGES := $(patsubst $(SRC_DIR)/%.md,$(OUT_DIR)/%.html,$(SOURCES))

.PHONY: all build clean test coverage lint check deps package ci

all: build

deps:
	npm install

build: $(PAGES)

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md tools/build.js
	@mkdir -p $(OUT_DIR)
	node tools/build.js $< $@

check:
	@test -d $(SRC_DIR) || (echo "Missing src dir" && exit 1)

test: build
	node --test

coverage: build
	@mkdir -p coverage
	node --test --experimental-test-coverage \
	  --test-reporter=spec --test-reporter-destination=stdout \
	  --test-reporter=lcov --test-reporter-destination=coverage/lcov.info

lint: node_modules
	npm run --silent lint

package: build test
	npm pack

clean:
	rm -rf $(OUT_DIR) coverage *.tgz

ci: clean deps check lint test package

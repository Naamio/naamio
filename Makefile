SHELL := /bin/bash

CONTAINER_URL = naamio/naamio:0.0
CONTAINER_NAME = naamio

UNAME = ${shell uname}

# set EXECUTABLE_DIRECTORY according to your specific environment
ifeq ($(UNAME), Darwin)
	PLATFORM = x86_64-apple-macosx10.10
	EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
	TEST_RESOURCES_DIRECTORY = ./.build/${PLATFORM}/debug/NaamioWebTests.xctest/Contents/app/
else ifeq ($(UNAME), Linux)
	PLATFORM = x86_64-unknown-linux
	EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
	TEST_RESOURCES_DIRECTORY = ${EXECUTABLE_DIRECTORY}/app/
endif

RUN_RESOURCES_DIRECTORY = ${EXECUTABLE_DIRECTORY}

clean:
	if	[ -d ".build" ]; then \
		rm -rf .build ; \
	fi

build: clean
	@echo --- Building Naamio
	swift build

test: build
	mkdir -p ${TEST_RESOURCES_DIRECTORY}
	cp -r ./Tests/NaamioWebTests/NaamioWebTestContent/* ${TEST_RESOURCES_DIRECTORY}
	export NAAMIO_TEMPLATES=$(TEST_RESOURCES_DIRECTORY)_templates/ && \
	echo Testing templates at "$${NAAMIO_TEMPLATES}" && \
	swift test

run: build
	@echo --- Invoking Naamio executable
	./.build/debug/Naamio

build-release: clean
	docker run -v $$(pwd):/tmp/naamio -w /tmp/naamio -it ibmcom/swift-ubuntu:4.0 swift build -c release -Xcc -fblocks -Xlinker -L/usr/local/lib -Xswiftc -whole-module-optimization

clean-container:

	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	-docker rmi $(CONTAINER_URL)

build-container: clean-container build-release

	docker build -t $(CONTAINER_URL) .

.PHONY: build test run

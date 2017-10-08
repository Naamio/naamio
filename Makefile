SHELL := /bin/bash

PRODUCT_NAME = naamio
PRODUCT_VERSION = 0.0
CONTAINER_URL = naamio/$(PRODUCT_NAME):$(PRODUCT_VERSION)

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

all: build-container

clean:
	if	[ -d ".build" ]; then \
		rm -rf .build ; \
	fi

build: clean
	@echo --- Building Naamio
	swift build

test: 
	mkdir -p ${TEST_RESOURCES_DIRECTORY}
	cp -r ./Tests/Web/WebTestContent/* ${TEST_RESOURCES_DIRECTORY}
	export NAAMIO_TEMPLATES=${TEST_RESOURCES_DIRECTORY}_templates/ && \
	echo Testing template at $${NAAMIO_TEMPLATES} && \
	swift test
	#docker run -v $$(pwd):/tmp/naamio -w /tmp/naamio -it ibmcom/swift-ubuntu:4.1 swift test

run: build
	mkdir -p ${TEST_RESOURCES_DIRECTORY}
	cp -r ./Tests/Web/WebTestContent/* ${TEST_RESOURCES_DIRECTORY}
	export NAAMIO_TEMPLATES=$(TEST_RESOURCES_DIRECTORY)_templates/ && \
	echo Testing template at "$${NAAMIO_TEMPLATES}" && \
	./.build/debug/Naamio

build-release: clean
	docker run -v $$(pwd):/tmp/$(PRODUCT_NAME) -w /tmp/$(PRODUCT_NAME) -it ibmcom/swift-ubuntu:4.1 swift build -c release -Xcc -fblocks -Xlinker -L/usr/local/lib -Xswiftc -whole-module-optimization

clean-container:

	-docker stop $(PRODUCT_NAME)
	-docker rm $(PRODUCT_NAME)
	-docker rmi $(CONTAINER_URL)

build-container: clean-container build-release

	docker build -t $(CONTAINER_URL) .

.PHONY: build test run

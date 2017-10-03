CONTAINER_URL = omnijarstudio/naamio:0.4
CONTAINER_NAME = naamio

clean:
	if	[ -d ".build" ]; then \
		rm -r .build ; \
	fi

build: clean
	@echo --- Building Naamio
	swift build

test: build
	swift test

run: build
	@echo --- Invoking Naamio executable
	./.build/debug/Naamio

build-release clean:
	docker run -v $$(pwd):/tmp/naamio -w /tmp/naamio -it ibmcom/swift-ubuntu:4.0 swift build -c release -Xcc -fblocks -Xlinker -L/usr/local/lib

clean-container:

	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	-docker rmi $(CONTAINER_URL)

build-container: clean-container build-release

	docker build -t $(CONTAINER_URL) .

.PHONY: build test run

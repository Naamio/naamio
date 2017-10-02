# Copyright (c) 2016 Omnijar Studio Oy 
# All rights reserved.
#
# This software is licensed under Omnijar Seneca License 1.0:
# 
# Permission is hereby granted, free of charge, to any person obtaining a 
# copy of this software and associated documentation files (the "Software"), 
# to use the Software for the enhancement of knowledge and to further 
# education. 
# 
# Permission is granted for the Software to be copied, modified, merged, 
# published, and distributed as original source, and to permit persons to 
# whom the Software is furnished to do so, for the above reasons, subject 
# to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software. The Software shall not
# be used for commercial or promotional purposes without written permission
# from the authors or copyright holders.
# 
# THE SOFTWARE IS NOT OPEN SOURCE. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
# WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH 
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Makefile
export NAAMIO_CI_BUILD_SCRIPTS_DIR=Package-Builder/build
# export SWIFT_TOOLCHAIN=/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2016-09-06-a.xctoolchain/usr/bin
export PATH := $(PATH):$(SWIFT_TOOLCHAIN)

-include Package-Builder/build/Makefile

Package-Builder/build/Makefile:
	@echo --- Fetching Package-Builder submodule
	git submodule update --init --remote --merge --recursive

build:
	@echo --- Building Naamio
	swift build

run: build
	@echo --- Invoking Naamio executable
	./.build/debug/Naamio

build-release:
	docker run -v $$(pwd):/tmp/naamio -w /tmp/naamio -it ibmcom/swift-ubuntu:4.0 swift build -c release -Xcc -fblocks-Xlinker -L/usr/local/lib

.PHONY: run

test: build
	swift test

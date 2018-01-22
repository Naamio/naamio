import XCTest

@testable import NaamioWebTests

XCTMain([
    testCase(TestRouting.allTests),
    testCase(TestServer.allTests),
    testCase(TestTemplating.allTests),
])
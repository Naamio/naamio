import XCTest

@testable import NaamioWebTests

XCTMain([
    testCase(TestServer.allTests),
    testCase(TestTemplating.allTests),
])
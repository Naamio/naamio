import XCTest

@testable import NaamioWebTests

XCTMain([
    testCase(TestTemplating.allTests)
    testCase(TestServer.allTests)
])
import XCTest

@testable import NaamioDataTests
@testable import NaamioWebTests

XCTMain([
    testCase(TestData.allTests),
    
    testCase(TestRouting.allTests),
    testCase(TestServer.allTests),
    testCase(TestTemplating.allTests),
])
import XCTest

@testable import NaamioStoreTests
@testable import NaamioWebTests

XCTMain([
    testCase(TestStore.allTests),

    testCase(TestRouting.allTests),
    testCase(TestServer.allTests),
    testCase(TestTemplating.allTests),
])
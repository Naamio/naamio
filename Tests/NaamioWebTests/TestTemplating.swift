import XCTest

import KituraNet

@testable import NaamioWeb

class TestTemplating: XCTestCase {

    static var allTests: [(String, (TestTemplating) -> () throws -> Void)] {
        return [
            ("Test Templating Instance", testTemplatingInstance),
        ]
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /// Tests a basic templating instance can be created with default settings.
    func testTemplatingInstance() {
        let templating = Templating()

        XCTAssertNotNil(templating)
    }
}
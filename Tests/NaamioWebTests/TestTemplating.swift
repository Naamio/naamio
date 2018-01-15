import XCTest

import KituraNet

@testable import NaamioWeb

class TestTemplating: XCTestCase {

    static var allTests: [(String, (TestTemplating) -> () throws -> Void)] {
        return [
            ("Test Templating Instance", testTemplatingInstance),
            ("Test Default Templating Instance", testDefaultInstance),
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

    /// Tests the default templating instance initiates and functions as expected.
    func testDefaultInstance() {
        XCTAssertNotNil(Templating.default)
        XCTAssertNotNil(Templating.default.templates)
        XCTAssertNotNil(Templating.default.path)
        XCTAssertEqual(Templating.default.templates.count, 2)
        print(Templating.default.path)
    }
}
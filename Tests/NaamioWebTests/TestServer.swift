@testable import NaamioCore
import XCTest

class TestServer: XCTestCase {

    let server:Server = Server()

    static var allTests: [(String, (TestServer) -> () throws -> Void)] {
        return [
            ("testServerStartup", testServerStartup)
        ]
    }
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testServerStartup() {
        // Set up server for this test
        
    }
}
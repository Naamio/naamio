import Foundation
import XCTest

@testable import NaamioData

protocol Test {
    func expectation(_ index: Int) -> XCTestExpectation
    func waitExpectation(timeout t: TimeInterval, handler: XCWaitCompletionHandler?)
}

extension Test {

    func doSetUp() {
    }

    func doTearDown() {
        // sleep(10)
    }

    func performTest(asyncTasks: (XCTestExpectation) -> Void...) {
        let queue = DispatchQueue(label: "Query queue")

        for (index, asyncTask) in asyncTasks.enumerated() {
            let expectation = self.expectation(index)
            queue.async() {
                asyncTask(expectation)
            }
        }

        waitExpectation(timeout: 10) { error in
            // blocks test until request completes
            XCTAssertNil(error)
        }
    }
}

extension XCTestCase: Test {
    func expectation(_ index: Int) -> XCTestExpectation {
        let expectationDescription = "\(type(of: self))-\(index)"
        return self.expectation(description: expectationDescription)
    }

    func waitExpectation(timeout t: TimeInterval, handler: XCWaitCompletionHandler?) {
        self.waitForExpectations(timeout: t, handler: handler)
    }
}

class TestData: XCTestCase {

    static var allTests: [(String, (TestData) -> () throws -> Void)] {
        return [
            ("Test Data Connection", testDataConnection),
        ]
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDataConnection() {
        performTest(asyncTasks: { expectation in
            let db = Database()
            db.connectToDatabase()

            expectation.fulfill()
        })
    }
}

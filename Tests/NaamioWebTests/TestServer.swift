import Foundation
import XCTest

import KituraNet

@testable import NaamioWeb

class TestServer: XCTestCase {

    let server:NaamioWeb.Server = Server()

    static var allTests: [(String, (TestServer) -> () throws -> Void)] {
        return [
            ("Test Server Startup", testServerStartup)
        ]
    }
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testServerStartup() {
        performServerTest { expectation in
            self.performRequest("get", path: "/", expectation: expectation) { response in
                expectation.fulfill()
            }
        }
    }

    func performServerTest(asyncTasks: (XCTestExpectation) -> Void...) {
        Server.start()

        let requestQueue = DispatchQueue(label: "Request queue")

        for (index, asyncTask) in asyncTasks.enumerated() {
            let expectation = self.expectation(index)
            requestQueue.async() {
                asyncTask(expectation)
            }
        }

        waitExpectation(timeout: 10) { error in
            // blocks test until request completes
            Server.stop()
            XCTAssertNil(error)
        }
    }

    
    func performRequest(_ method: String, path: String,  expectation: XCTestExpectation,
                        headers: [String: String]? = nil,
                        requestModifier: ((ClientRequest) -> Void)? = nil,
                        callback: @escaping (ClientResponse) -> Void) {
        var allHeaders = [String: String]()
        if  let headers = headers {
            for  (headerName, headerValue) in headers {
                allHeaders[headerName] = headerValue
            }
        }
        if allHeaders["Content-Type"] == nil {
            allHeaders["Content-Type"] = "text/plain"
        }
        let options: [ClientRequest.Options] =
            [.method(method), .hostname("localhost"), .port(8090), .path(path), .headers(allHeaders)]
        let req = HTTP.request(options) { response in
            guard let response = response else {
                XCTFail("response object is nil")
                expectation.fulfill()
                return
            }
            callback(response)
        }
        if let requestModifier = requestModifier {
            requestModifier(req)
        }
        req.end()
    }

    func performRequestSynchronous(_ method: String, path: String,  expectation: XCTestExpectation,
                        headers: [String: String]? = nil,
                        requestModifier: ((ClientRequest) -> Void)? = nil,
                        callback: @escaping (ClientResponse, DispatchGroup) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        performRequest(method, path: path, expectation: expectation, headers: headers,
                       requestModifier: requestModifier) { response in
                        callback(response, dispatchGroup)
        }
        dispatchGroup.wait()
    }
    

    func expectation(_ index: Int) -> XCTestExpectation {
        let expectationDescription = "\(type(of: self))-\(index)"
        return self.expectation(description: expectationDescription)
    }

    func waitExpectation(timeout t: TimeInterval, handler: XCWaitCompletionHandler?) {
        self.waitForExpectations(timeout: t, handler: handler)
    }
}
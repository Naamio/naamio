import Dispatch
import Foundation
import XCTest

import KituraNet

@testable import NaamioWeb
@testable import NaamioCore

class TestServer: XCTestCase {

    typealias BodyChecker = (String) -> Void


    static var allTests: [(String, (TestServer) -> () throws -> Void)] {
        return [
            ("Test Server Startup", testServerStartup)
            //("Test Parameter", testParameter),
            //("Test Parameter with Whitespace", testParameterWithWhiteSpace),
        ]
    }
    
    private let server:NaamioWeb.Server = Server()

    override func setUp() {
        super.setUp()

        Environment.readArgs()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests

    func testServerStartup() {
        measure {
            performServerTest { expectation in
                self.performRequest("get", path: "/", expectation: expectation) { response in
                    expectation.fulfill()
                }
            }
        }
    }

    // MARK: - Test Boilerplate

    private func performServerTest(asyncTasks: (XCTestExpectation) -> Void...) {
        Server.mode = .test
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

    private func performRequest(_ method: String, path: String,  expectation: XCTestExpectation,
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

    private func performRequestSynchronous(_ method: String, path: String,  expectation: XCTestExpectation,
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

    private func checkResponse(response: ClientResponse, expectedResponseText: String? = nil,
        expectedStatusCode: HTTPStatusCode = HTTPStatusCode.OK, bodyChecker: BodyChecker? = nil) {
        XCTAssertEqual(response.statusCode, expectedStatusCode,
                        "No success status code returned")
        if let optionalBody = try? response.readString(), let body = optionalBody {
            if let expectedResponseText = expectedResponseText {
                XCTAssertEqual(body, expectedResponseText, "mismatch in body")
            }
            bodyChecker?(body)
        } else {
            XCTFail("No response body")
        }

    }

    private func runGetResponseTest(path: String, expectedResponseText: String? = nil,
                                    expectedStatusCode: HTTPStatusCode = HTTPStatusCode.OK,
                                    bodyChecker: BodyChecker? = nil) {
        performServerTest { expectation in
            self.performRequest("get", path: path, expectation: expectation) { response in
                self.checkResponse(response: response, expectedResponseText: expectedResponseText,
                                    expectedStatusCode: expectedStatusCode, bodyChecker: bodyChecker)
                expectation.fulfill()
            }
        }
    }

    private func runTestParameter(user: String) {
        let userInPath = user.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? user
        let responseText = "<!DOCTYPE html><html><body><b>User:</b> {{ user }}</body></html>"
        runGetResponseTest(path: "/users/\(userInPath)", expectedResponseText: responseText)
    }

    private func runTestUnknownPath(path: String) {
        runGetResponseTest(path: path,
                            expectedResponseText: "Route not found in Naamio test application!",
                            expectedStatusCode: HTTPStatusCode.notFound)
    }

    // MARK: - Expectations

    func expectation(_ index: Int) -> XCTestExpectation {
        let expectationDescription = "\(type(of: self))-\(index)"
        return expectation(description: expectationDescription)
    }

    func waitExpectation(timeout t: TimeInterval, handler: XCWaitCompletionHandler?) {
        waitForExpectations(timeout: t, handler: handler)
    }
}

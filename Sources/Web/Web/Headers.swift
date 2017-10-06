import Foundation

import Kitura
//import RxSwift

class HeadersRegistry {
    
    /// MARK: - Static Public
    
    static func new() -> HeadersRegistry {
        return HeadersRegistry.headersRegistry
    }
    
    /// MARK: - Static Private
    
    private static let headersRegistry: HeadersRegistry
        = HeadersRegistry()
    
    /// MARK: - Instance Public
    
    private let headers: [String: String]
    
    /// MARK: - Instance Private
    
    private init() {
        headers = [String: String]()
    }
}

class HeadersMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT"
        response.headers["Server"] = "Naamio/0.2.2"
        response.headers["X-Powered-By"] = "Naamio/0.2.2"
        response.headers["Content-Type"] = "application/xhtml+xml; charset=utf-8"
        next()
    }
}
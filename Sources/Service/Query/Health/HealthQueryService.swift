import NaamioAPI
import NaamioCore
import NaamioHealth

/// Public API for retrieving health data.
public class HealthQueryService {
    let handler: HealthHandler

    /// Initializes a new `HealthQueryService` instance with a handler.
    ///
    /// - Parameters:
    ///   - with: `HealthHandler`
    public init(with handler: HealthHandler) {
        self.handler = handler
    }
}

extension HealthQueryService: HealthServiceQueryable {
    public func getHealth() throws -> HealthQueryResponse {
        let health = try handler.getHealth()
        
        let response = HealthQueryResponse(from: health)

        return response
    }
}

extension HealthQueryResponse {
    public convenience init(from model: HealthModel) {
        self.init()
    }
}
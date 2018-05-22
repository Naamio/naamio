import NaamioAPI
import NaamioCore

/// Public API for retrieving metrics data.
public class MetricsQueryService {
    let handler: MetricsHandler

    /// Initializes a new `MetricsQueryService` instance with a handler.
    ///
    /// - Parameters:
    ///   - with: `MetricsHandler`
    public init(with handler: MetricsHandler) {
        self.handler = handler
    }
}

extension MetricsQueryService: MetricsServiceQueryable {
    public func getMetrics() throws -> MetricsQueryResponse {
        let metrics = try handler.getMetrics()
        
        let response = MetricsQueryResponse(from: metrics)

        return response
    }
}
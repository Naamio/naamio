import NaamioAPI

public protocol MetricsServiceQueryable {
    /// Gets the current metrics of the application.
    func getMetrics() throws -> MetricsQueryResponse
}
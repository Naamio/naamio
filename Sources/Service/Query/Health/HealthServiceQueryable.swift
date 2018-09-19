import NaamioAPI

public protocol HealthServiceQueryable {
    /// Gets the current health of the application.
    func getHealth() throws -> HealthQueryResponse
}
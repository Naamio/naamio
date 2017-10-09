import PalveluService

/// Route identifiers for the health service. Each variant is associated with a route,
/// and it corresponds to a service call.
public enum HealthQueryRoutes: UInt8 {
    case getHealth
}

extension HealthQueryRoutes: RouteRepresentable {
    public var route: Route {
        switch self {
            case .getHealth:
                return Route(url: "/health", method: .get)
        }
    }
}
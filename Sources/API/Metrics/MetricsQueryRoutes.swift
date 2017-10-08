import PalveluService

/// Route identifiers for the metrics service. Each variant is associated with a route,
/// and it corresponds to a service call.
public enum MetricsQueryRoutes: UInt8 {
    case getMetrics
}

extension MetricsQueryRoutes: RouteRepresentable {
    public var route: Route {
        switch self {
            case .getMetrics:
                return Route(url: "/metrics", method: .get)
        }
    }
}
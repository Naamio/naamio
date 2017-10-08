import PalveluService

import NaamioAPI

/// Router specific to the metrics service.
public class MetricsQueryHandler<R: Routing>: ServiceRouter<R, MetricsQueryRoutes> {
    
    let service: MetricsServiceQueryable

    /// Initializes this router with a `Routing` object and a
    /// `MetricsServiceCallable` object.
    public init(with router: R, service: MetricsServiceQueryable) {
        self.service = service
        super.init(with: router)
    }

    /// Overridden routes for metrics service.
    public override func initializeRoutes() {
        add(route: .getMetrics) { request, response in
            let metrics = try self.service.getMetrics()
            try response.respondJSON(with: metrics)
        }
    }
}
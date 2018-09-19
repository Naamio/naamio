import Foundation

import PalveluService
import NaamioCore

/// # Server
///
/// Operates the main server entry-point for `Naamio`, initializing
/// default configuration, logging, and staging modes.
public class Server: ServiceRunner {

    /// Initializes the `Server` object, configuring logging and 
    /// miscellaneous settings.
    public override init() {
        super.init()
    }

    /// Runs the `ServiceRunner` with default settings, initializing
    /// the routing for the web application, and starting the logging.
    public func run() {
        Log.start(Configuration.settings.mode == .test ? .debug : .info)
        
        Routes.defineRoutes()

        // Add HTTP Server to listen on port 8090
        let port = Configuration.settings.web.port
        
        super.addRouter(Routes.routers.view)

        do {
            if Configuration.settings.mode == .test {
                try super.test(withPort: port)
            } else {
                try super.run(withPort: port)
            }
        } catch {
            Log.error("Cannot start web server on port \(port)")
        }
    }
}

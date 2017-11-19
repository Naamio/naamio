import Foundation

import Kitura

import NaamioCore

/// Available modes for `Naamio` to operate under. 
public enum ServerMode: String {

    /// Production is the most lightweight and performant mode, with
    /// minimal verbosity.
    case production = "production"
    
    /// Development provides debugging options, verbose logging, 
    /// and the ability to hot-switch between themes.
    case development = "development"
    
    init(value: String) {
        switch value {
        case "development": self = .development
        case "production": self = .production
        default: self = .development
        }
    }
}

/// # Server
///
/// Operates the main server entry-point for `Naamio`, initializing
/// default configuration, logging, and staging modes.
public class Server {
    
    /// Mode at which the server is running. Useful for 
    /// development purposes as the server can be used as
    /// an instant feedback agent whilst designing and developing
    /// aspects of an application.
    public static var mode: ServerMode = .development

    /// Initializes the `Server` object, configuring logging and 
    /// miscellaneous settings.
    public init() {
        
    }

    /// Starts the `Naamio` web application server. 
    public class func start() {        
        let router = Router()

        Templating.load()
        
        // Set default view path to template path.
        router.viewsPath = Templating.path

        Routes.defineRoutes(router: router)

        // Add HTTP Server to listen on port 8090
        let port = Config.settings["naamio.port"] as? Int ?? 8090
        
        Kitura.addHTTPServer(onPort: port, with: router)

        // start the framework - the servers added until now will start listening
        Kitura.run()
    }
    
    /// Translates the option to the enum value.
    public class func getServerMode(_ mode: String) -> (mode: ServerMode, value: String) {
        return (ServerMode(value: mode), mode)
    }
}

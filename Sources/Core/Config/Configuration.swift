import Foundation

protocol ServiceConfigurable {

    var port: Int { get set }

}

/// Available modes for services to operate under. 
public enum RunMode: String {

    /// Test executes the process without attaching to STDIN
    /// to allow for tests to execute before the process exits
    /// normally.
    case test = "test"

    /// Production is the most lightweight and performant mode, with
    /// minimal verbosity.
    case production = "production"
    
    /// Development provides debugging options, verbose logging, 
    /// and the ability to hot-switch between themes.
    case development = "development"
    
    init(value: String) {
        switch value {
        case "test": self = .test
        case "development": self = .development
        case "production": self = .production
        default: self = .development
        }
    }
}

/// # Configuration
/// Manages the configuration for `Naamio`. 
public struct Configuration {

    /// MARK: - Static Properties
    
    /// Settings are static configuration parameters 
    /// used during the programs runtime.
    public static var settings = Configuration()
    
    /// Loads the specified configuration file.
    ///
    /// - Parameters:
    ///   - path: Path of configuration file as a `String`.
    ///
    /// TODO: Complete this.
    public static func load(from path: String) {
        Log.warn("Cannot load configuration from file yet. Specify configuration by parameters instead.")
    }

    
    
    /// MARK: - Instance Properties

    /// Mode at which the server is running. Useful for 
    /// development purposes as the server can be used as
    /// an instant feedback agent whilst designing and developing
    /// aspects of an application.
    public var mode: RunMode = .development

    public var logs = "/var/log/naamio.log"

    public var web = WebConfiguration()

    public var api = ServiceConfiguration()

}



public struct ServiceConfiguration: ServiceConfigurable {

    public var port: Int = 9080

}

public struct WebConfiguration: ServiceConfigurable {

    public var port: Int = 8090

    public var source = "public"

    public var templates = "_templates"

}


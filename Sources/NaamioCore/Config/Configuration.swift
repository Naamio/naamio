import Foundation

/// # Configuration
/// Manages the configuration for `Naamio`. 
public class Config {

    /// MARK: - Static Properties
    
    
    /// Settings are static configuration parameters 
    /// used during the programs runtime.
    public static var settings: [String: Any] = ["naamio.env"        :  "development",
                                                 "naamio.logs"       :  "/var/log/naamio.log",
                                                 "naamio.port"       :  8090,
                                                 "naamio.source"     :  "public",
                                                 "naamio.templates"  :  "_templates"]
    
    /// Loads the specified configuration file.
    ///
    /// - Parameters:
    ///   - path: Path of configuration file as a `String`.
    ///
    /// TODO: Complete this.
    public class func load(from path: String) {
        Log.warn("Cannot load configuration from file yet. Specify configuration by parameters instead.")
    }
    
    /// MARK: - Instance Properties

}

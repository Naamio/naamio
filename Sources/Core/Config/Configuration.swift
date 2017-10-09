import Foundation

/// # Configuration
/// Manages the configuration for `Naamio`. 
public struct Configuration {

    /// MARK: - Static Properties
    
    /// Settings are static configuration parameters 
    /// used during the programs runtime.
    public static var settings = Settings()
    
    /// Loads the specified configuration file.
    ///
    /// - Parameters:
    ///   - path: Path of configuration file as a `String`.
    ///
    /// TODO: Complete this.
    public static func load(from path: String) {
        Log.warn("Cannot load configuration from file yet. Specify configuration by parameters instead.")
    }
}
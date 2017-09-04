
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
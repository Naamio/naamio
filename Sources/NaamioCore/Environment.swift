import Foundation

/// Gets the environment variable by name.
public func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { 
        return nil 
    }
    
    return String(utf8String: rawValue)
}

/// Sets or overrides the environment variable, specified by name.
/// - Parameters:
/// 
public func setEnvironmentVar(name: String, value: String, overwrite: Bool = true) {
    setenv(name, value, overwrite ? 1 : 0)
}

public class Environment {
    public static func readArgs() {
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_ENV") ?? "development", forKey: "naamio.env")
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_STENCILS") ?? "_stencils/leaf/", forKey: "naamio.stencils")
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_SOURCE") ?? "public", forKey: "naamio.source")
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_PORT") ?? "8090", forKey: "naamio.port")
    }
}
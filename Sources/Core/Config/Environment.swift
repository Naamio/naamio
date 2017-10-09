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
        let runModeEnv = getEnvironmentVar("NAAMIO_ENV") ?? "development"
        let portEnv = getEnvironmentVar("NAAMIO_PORT") ?? "8090"

        guard case Configuration.settings.mode = RunMode(rawValue: runModeEnv) else {
            Log.error("Run mode '\(runModeEnv)' not valid")
            return
        }

        Configuration.settings.logs = getEnvironmentVar("NAAMIO_LOGS") ?? "/var/log/naamio.log"
        Configuration.settings.web.templates = getEnvironmentVar("NAAMIO_TEMPLATES") ?? "_templates/leaf/"
        Configuration.settings.web.source = getEnvironmentVar("NAAMIO_SOURCE") ?? "public"
        
        guard case Configuration.settings.web.port = Int(portEnv) else {
            Log.error("Port number '\(portEnv)' not valid")
            return
        }
    }
}
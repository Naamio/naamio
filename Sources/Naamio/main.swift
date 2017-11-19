import Foundation
import NaamioCore
import NaamioWeb

/// Gets the environment variable by name.
func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { 
        return nil 
    }
    
    return String(utf8String: rawValue)
}

/// Sets or overrides the environment variable, specified by name.
/// - Parameters:
/// 
func setEnvironmentVar(name: String, value: String, overwrite: Bool = true) {
    setenv(name, value, overwrite ? 1 : 0)
}

// Set default environment to development.
setEnvironmentVar(name: "NAAMIO_ENV", value: "development", overwrite: false)
setEnvironmentVar(name: "NAAMIO_SOURCE", value: "public", overwrite: false)
setEnvironmentVar(name: "NAAMIO_TEMPLATES", value: "_templates/leaf", overwrite: false)
setEnvironmentVar(name: "NAAMIO_PORT", value: "8090", overwrite: false)

Log.logger = ConsoleLogger()

let configPath = Config.settings["naamio.source"] as? String ?? "public"
Config.load(from: "\(configPath)/naamio.yml")

Console.loadConfig()
Server.start()

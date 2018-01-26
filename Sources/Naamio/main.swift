import Foundation
import NaamioCore
import NaamioWeb

// Set default environment to development.
setEnvironmentVar(name: "NAAMIO_ENV", value: "development", overwrite: false)
setEnvironmentVar(name: "NAAMIO_SOURCE", value: "public", overwrite: false)
setEnvironmentVar(name: "NAAMIO_STENCILS", value: "_stencils/leaf", overwrite: false)
setEnvironmentVar(name: "NAAMIO_PORT", value: "8090", overwrite: false)

Log.logger = ConsoleLogger()

let configPath = Config.settings["naamio.templates"] as? String ?? "public"
Config.load(from: "\(configPath)/naamio.yml")

Console.loadConfig()
Server.start()

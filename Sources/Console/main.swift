import Foundation
import NaamioCore
import NaamioWeb

// Set default environment to development.
setEnvironmentVar(name: "NAAMIO_ENV", value: "development", overwrite: false)
setEnvironmentVar(name: "NAAMIO_SOURCE", value: "public", overwrite: false)
setEnvironmentVar(name: "NAAMIO_TEMPLATES", value: "_templates/leaf", overwrite: false)
setEnvironmentVar(name: "NAAMIO_PORT", value: "8090", overwrite: false)

let configPath = Configuration.settings.web.templates
Configuration.load(from: "\(configPath)/naamio.yml")

Console.loadConfig()

let server = Server()
server.run()

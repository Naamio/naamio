import Foundation
import HeliumLogger
import LoggerAPI
import NaamioCore

/// Possible options via the console for the system.
enum OptionType: String {
    case help = "help"

    case environment = "development"
    
    case theme = "theme"
    
    case unknown
    
    init(value: String) {
        switch value {
        case "t": self = .theme
        case "e": self = .environment
        case "h": self = .help
        default: self = .unknown
        }
    }
}

/// Provides access to the system via the console.
class Console {
    
    /// Loads console-based environment settings into the 
    /// configuration file, overriding defaults.
    class func loadConfig() {
        Console.readArgs()
        Environment.readArgs()
    }
    
    /// Reads the arguments from the console provided at
    /// execution, overriding any previously provided
    /// configuration.
    class func readArgs() {
        for (index, option) in CommandLine.arguments.enumerated() {
            switch option {
            case "e":
                // Set default environment to development.
                setEnvironmentVar(name: "NAAMIO_ENV", value: CommandLine.arguments[index+1], overwrite: false)
            case "h":
                printHelp()
            case "s":
                setEnvironmentVar(name: "NAAMIO_SOURCE", value: CommandLine.arguments[index+1], overwrite: false)
            case "t":
                setEnvironmentVar(name: "NAAMIO_STENCILS", value: CommandLine.arguments[index+1], overwrite: false)
            case "p":
                setEnvironmentVar(name: "NAAMIO_PORT", value: CommandLine.arguments[index+1], overwrite: false)
            default: break
            }
        }
    }

    /// Prints the usage for the system.
    class func printUsage() {
        let executableName = NSString(string: CommandLine.arguments[0]).lastPathComponent
        let usageString = "Usage: \(executableName) [-e <environment>] [-h] [-s <source>] [-t <templates>]\n" +
                          "                         [-p <port>]" +
                          "  e: Environment mode (i.e. \"development\" or \"production\")\n" +
                          "  s: Source of the app content (default is \"public\" folder in current working directory)\n" +
                          "  t: Theme to load (as a path; can be relative, or git repository)\n"
        
        Log.info(usageString)
    }
    
    /// Prints help to the console.
    class func printHelp() {
        printUsage()
    }
    
    /// Translates the option to the enum value.
    func getOption(_ option: String) -> (option: OptionType, value: String) {
        return (OptionType(value: option), option)
    }
}

/// Custom console logger for printing the output of the logs
/// to the console and any system logs. Uses `HeliumLogger`
/// under the hood whilst abstracting to allow additional
/// functionality to be added.
class ConsoleLogger : Logger {
    
    // Uses `HeliumLogger` to simplify text stream logging.
    private let logger = HeliumLogger(.entry)
    
    init() {
        logger.format = "(%msg)"
    }
    
    func log(_ type: LoggerMessageType, msg: String,
             functionName: String, lineNum: Int, fileName: String) {
        logger.log(type, msg: msg, functionName: functionName, lineNum: lineNum, fileName: fileName)
    }
    
    func isLogging(_ level: LoggerMessageType) -> Bool {
        return logger.isLogging(level)
    }
}

/**
 * Omnijar Seneca License 1.0
 *
 * Copyright (c) 2016 Omnijar Studio Oy
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to use the Software for the enhancement of knowledge and to further
 * education.
 *
 * Permission is granted for the Software to be copied, modified, merged,
 * published, and distributed as original source, and to permit persons to
 * whom the Software is furnished to do so, for the above reasons, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software. The Software shall not
 * be used for commercial or promotional purposes without written permission
 * from the authors or copyright holders.
 *
 * THE SOFTWARE IS NOT OPEN SOURCE. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/

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
        
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_ENV") ?? "development", forKey: "naamio.env")
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_TEMPLATES") ?? "content/themes/leaf", forKey: "naamio.templates")
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_SOURCE") ?? "public", forKey: "naamio.source")
        Config.settings.updateValue(getEnvironmentVar("NAAMIO_PORT") ?? "8090", forKey: "naamio.port")
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
                setEnvironmentVar(name: "NAAMIO_THEME", value: CommandLine.arguments[index+1], overwrite: false)
            default: break
            }
        }
    }

    /// Prints the usage for the system.
    class func printUsage() {
        let executableName = NSString(string: CommandLine.arguments[0]).lastPathComponent
        let usageString = "Usage: \(executableName) [-e <environment>] [-h] [-s <source>] [-t <templates>]\n" +
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

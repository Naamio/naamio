import Foundation

import Loki

typealias LogAPI = Loki

// Log provides direct access to log messages.
public class Log {

    public static func start(_ logLevel: LogLevel = .info) {
        Loki.sourceName = "Naamio"  // Name of the app (optional)

        let console = ConsoleDestination()      // define console destination (stdout)
        console.minLevel = logLevel
        console.format = "$L: $M"
        Loki.addDestination(console)

        let file = FileDestination() 
        file.url = URL(fileURLWithPath: Configuration.settings.logs)
        Loki.addDestination(file)   // log to file
    }

    // Prints a trace message to the relevant IO stream(s).
    public static func trace(_ msg: String,
                             functionName: String = #function,
                             lineNum: Int = #line,
                             filePath: String = #file) {
        LogAPI.debug(msg, function: functionName, line: lineNum, file: filePath)
    }
    
    // Prints an information message to the relevant IO stream(s).
    public static func info(_ msg: String,
                            functionName: String = #function,
                            lineNum: Int = #line,
                            filePath: String = #file) {
        LogAPI.info(msg, function: functionName, line: lineNum, file: filePath)
    }
    
    // Prints a warning message to the reelvant IO stream(s).
    public static func warn(_ msg: String,
                            functionName: String = #function,
                            lineNum: Int = #line,
                            filePath: String = #file) {
        LogAPI.warn(msg, function: functionName, line: lineNum, file: filePath)
    }
    
    // Prints an error message to the relevant IO stream(s).
    public static func error(_ msg: String,
                             functionName: String = #function,
                             lineNum: Int = #line,
                             filePath: String = #file) {
        LogAPI.error(msg, function: functionName, line: lineNum, file: filePath)
    }
}

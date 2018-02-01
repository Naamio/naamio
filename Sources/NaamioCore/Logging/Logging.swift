import Dispatch

import Loki

typealias LogAPI = Loki

// Log provides direct access to log messages.
public class Log {

    public static func start() {
        Loki.sourceName = "Naamio"  // Name of the app (optional)
        Loki.logLevel = .info       // default (supports 4 other levels)

        let console = ConsoleDestination()      // define console destination (stdout)
        Loki.addDestination(console)

        if let file = FileDestination(inPath: "/tmp/naamio.log") {
            Loki.addDestination(file)   // log to file
        }

        let queue = DispatchQueue(label: "logging", qos: .utility)
        Loki.dispatchQueue = queue          // queue for async logging   
    }

    // Prints a trace message to the relevant IO stream(s).
    public static func trace(_ msg: String,
                             functionName: String = #function,
                             lineNum: Int = #line,
                             filePath: String = #file) {
        LogAPI.debug(msg, functionName: functionName, lineNum: lineNum, filePath: filePath)
    }
    
    // Prints an information message to the relevant IO stream(s).
    public static func info(_ msg: String,
                            functionName: String = #function,
                            lineNum: Int = #line,
                            filePath: String = #file) {
        LogAPI.info(msg, functionName: functionName, lineNum: lineNum, filePath: filePath)
    }
    
    // Prints a warning message to the reelvant IO stream(s).
    public static func warn(_ msg: String,
                            functionName: String = #function,
                            lineNum: Int = #line,
                            filePath: String = #file) {
        LogAPI.warn(msg, functionName: functionName, lineNum: lineNum, filePath: filePath)
    }
    
    // Prints an error message to the relevant IO stream(s).
    public static func error(_ msg: String,
                             functionName: String = #function,
                             lineNum: Int = #line,
                             filePath: String = #file) {
        LogAPI.error(msg, functionName: functionName, lineNum: lineNum, filePath: filePath)
    }
}

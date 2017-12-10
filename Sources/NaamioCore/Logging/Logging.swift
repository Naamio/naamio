import LoggerAPI

typealias LogAPI = LoggerAPI.Log

// Log provides direct access to log messages.
public class Log {
    
    // Logger used to format and write log messages.
    public static var logger: Logger? {
        didSet {
            LogAPI.logger = logger
        }
    }
    
    // Prints a trace message to the relevant IO stream(s).
    public static func trace(_ msg: String) {
        LogAPI.debug(msg)
    }
    
    // Prints an information message to the relevant IO stream(s).
    public static func info(_ msg: String) {
        LogAPI.info(msg)
    }
    
    // Prints a warning message to the reelvant IO stream(s).
    public static func warn(_ msg: String) {
        LogAPI.info(msg)
    }
    
    // Prints an error message to the relevant IO stream(s).
    public static func error(_ msg: String) {
        LogAPI.error(msg)
    }
}

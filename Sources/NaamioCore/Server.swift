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

import Kitura

/// Available modes for `Naamio` to operate under. 
public enum ServerMode: String {

    /// Production is the most lightweight and performant mode, with
    /// minimal verbosity.
    case production = "production"
    
    /// Development provides debugging options, verbose logging, 
    /// and the ability to hot-switch between themes.
    case development = "development"
    
    init(value: String) {
        switch value {
        case "development": self = .development
        case "production": self = .production
        default: self = .development
        }
    }
}

/// # Server
///
/// Operates the main server entry-point for `Naamio`, initializing
/// default configuration, logging, and staging modes.
public class Server {
    
    /// Mode at which the server is running. Useful for 
    /// development purposes as the server can be used as
    /// an instant feedback agent whilst designing and developing
    /// aspects of an application.
    public static var mode: ServerMode = .development

    /// Initializes the `Server` object, configuring logging and 
    /// miscellaneous settings.
    public init() {
        
    }

    /// Starts the `Naamio` web application server. 
    public class func start() {        
        let router = Router()

        Templating.load()
        
        // Set default view path to template path.
        router.viewsPath = Templating.path

        Routes.defineRoutes(router: router)

        // Add HTTP Server to listen on port 8090
        let port = Config.settings["naamio.port"] as? Int ?? 8090
        
        Kitura.addHTTPServer(onPort: port, with: router)

        // start the framework - the servers added until now will start listening
        Kitura.run()
    }
    
    /// Translates the option to the enum value.
    public class func getServerMode(_ mode: String) -> (mode: ServerMode, value: String) {
        return (ServerMode(value: mode), mode)
    }
}

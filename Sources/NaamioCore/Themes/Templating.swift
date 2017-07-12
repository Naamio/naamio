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

/// Templating provides the tools necessary to take content
/// and provide it in a structured method to the end-user.
class Templating {
    
    private static let templateSuffix = "stencil"
    
    static var templates: [String] = {
        let resources = Resources()
        
        return resources.getResources(from: Templating.path, withSuffix: templateSuffix)
    }()

    /// The path of the templates.
    static var path: String {
        return Config.settings["naamio.templates"] as? String ?? "_templates/leaf"
    }

    /// Loads the templates into memory for safe and efficient
    /// processing at runtime.
    static func load() {
        
    }
}
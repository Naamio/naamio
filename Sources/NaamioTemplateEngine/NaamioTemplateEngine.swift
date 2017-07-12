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


import KituraTemplateEngine
import Malline
import PathKit
import Foundation



public class NaamioTemplateEngine: TemplateEngine {
    public var fileExtension: String { return "stencil" }
    private let `extension`: Extension
    
    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
    }
    
    public func render(filePath: String, context: [String: Any]) throws -> String {
        let templatePath = Path(filePath)
        let templateDirectory = templatePath.parent()

        let loader = FileSystemLoader(paths: [templateDirectory])
        `extension`.registerFilter("assets", filter: assetsFilter)
        let environment = Environment(loader: loader, extensions: [`extension`])
        var context = context
        context["loader"] = loader
        
        return try environment.renderStencil(name: templatePath.lastComponent,  context: context)
    }
    
    func assetsFilter(value: Any?, arguments: [Any?]) throws -> Any? {
        var path: String
        
        if let value = arguments.first as? String {
            path = value
        } else {
            throw StencilSyntaxError("Assets tag must be called with a String argument")
        }
        
        path = "/assets" + path
        
        /*
        if let value = value as? String {
            return "/assets" + value
        }
 */
        
        return path
    }
    
    /*public func render(filePath: String, context: [String: Any]) throws -> String {
        // Define the `pluralize` filter.
        //
        // {{# pluralize(count) }}...{{/ }} renders the plural form of the
        // section content if the `count` argument is greater than 1.
        let pluralize = Filter { (count: Int?, info: RenderingInfo) in
            
            // The inner content of the section tag:
            var string = info.tag.innerTemplateString
            
            // Pluralize if needed:
            if let count = count, count > 1 {
                string += "s"  // naive
            }
            
            return Rendering(string)
        }
        
        #if os(Linux) && !swift(>=3.1) // using !swift(>=3.1) since < is not allowed in version conditions
            return "GRMustache is not supported on Linux with Swift version less than 3.1.\n" +
            "Please update your Swift to version greater or equal than 3.1"
        #else
            let template = try Template(path: filePath)
            template.registerInBaseContext("pluralize", Box(pluralize))
            return try template.render(with: Box(context))
        #endif
    }*/
}


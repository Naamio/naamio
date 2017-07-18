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
import KituraMarkdown
import NaamioTemplateEngine

class Routes {
    
    class func defineRoutes(router: Router) {
        let sourcePath = Config.settings["naamio.source"] as! String
        let templatesPath = Config.settings["naamio.templates"] as! String
        let assetsPath = sourcePath + "/assets"
        let postsPath = sourcePath + "_/posts"
        
        var name: String?
        
        // This route executes the echo middleware
        router.all(middleware: BasicAuthMiddleware())
        
        router.all("/*", middleware: HeadersMiddleware())
        
        /*
        if (FileManager.default.fileExists(atPath: sourcePath)) {
            router.all("/", middleware: StaticFileServer(path: sourcePath))
        }*/
        
        if (FileManager.default.fileExists(atPath: templatesPath)) {
            Log.info("Templates folder '\(templatesPath)' found. Loading templates")
            router.setDefault(templateEngine: NaamioTemplateEngine())
        }
        
        if (FileManager.default.fileExists(atPath: postsPath)) {
            Log.info("Posts folder '\(postsPath)' found. Loading posts at '/posts'")
        }
        
        if (FileManager.default.fileExists(atPath: assetsPath)) {
            Log.info("Assets folder '\(assetsPath)' found. Loading static file server at '/assets'")
            router.all("/assets", middleware: StaticFileServer(path: assetsPath))
        }
        
        router.add(templateEngine: KituraMarkdown())
        
        router.get("/") { _, response, next in
            let context: [String: Any] = [
                "meta_title": "Naamio",
                "count": 4
            ]
            
            try response.render("home", context: context).end()
        }
        
        for template in Templating.templates {
            let templateName = NSString(string: template).deletingPathExtension
            
            Log.info("Registering template '/\(templateName)")
            
            router.get("/\(templateName)") { request, response, next in
                defer {
                    next()
                }
                do {
                    let context: [String: Any] = [
                        "meta": [
                            "title": "Naamio"
                        ],
                        "page": [
                            "title": templateName
                        ],
                        "partials": [
                            "header": true,
                            "footer": true
                        ]
                    ]
                    
                    try response.render(templateName, context: context).end()
                } catch {
                    Log.error("Failed to render template \(error)")
                }
            }
            
            router.get("/\(templateName)/:id") { request, response, next in
                defer {
                    next()
                }
                do {
                    let context: [String: Any] = [
                        "meta": [
                            "title": "Naamio"
                        ],
                        "page": [
                            "title": templateName
                        ],
                        "partials": [
                            "header": true,
                            "footer": true
                        ],
                        "data": [
                            "id": request.parameters["id"]
                        ]
                    ]
                    
                    try response.render(templateName, context: context).end()
                } catch {
                    Log.error("Failed to render template \(error)")
                }
            }
        }
        
        // Handles any errors that get set
        router.error { request, response, next in
            response.headers["content-type"] = "text/plain; charset=utf-8"
            let errorDescription: String
            if let error = response.error {
                errorDescription = "\(error)"
            } else {
                errorDescription = "Unknown error"
            }
            try response.send("Caught the error: \(errorDescription)").end()
        }
        
        // A custom Not found handler
        router.all { request, response, next in
            if response.statusCode == .unknown {
                // Remove this wrapping if statement, if you want to handle requests to / as well
                if request.originalURL != "/" && request.originalURL != "" {
                    let context: [String: Any] = [
                        "meta": [
                            "title": "Oops!"
                        ],
                        "not-found": request.originalURL,
                        "page": [
                            "title": "404"
                        ],
                        "partials": [
                            "header": true,
                            "footer": true
                        ]
                    ]
                    
                    try response.status(.notFound).render("40x", context: context).end()
                }
            }
            next()
        }
    }
}

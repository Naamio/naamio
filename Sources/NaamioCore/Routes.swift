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
        
        if (FileManager.default.fileExists(atPath: sourcePath + "/content")) {
            Log.info("Content folder /content found. Loading static file server at '/content'")
            router.all("/", middleware: StaticFileServer(path: sourcePath + "/content"))
        }
        
        router.add(templateEngine: KituraMarkdown())
        
        router.get("/") { _, response, next in
            defer {
                next()
            }
            do {
                let context: [String: Any] = [
                    "meta": [
                        "title": "Naamio"
                    ],
                    "page": [
                        "title": "Home"
                    ],
                    "partials": [
                        "header": true,
                        "footer": true
                    ]
                ]
                
                try response.render("index", context: context).end()
            } catch {
                Log.error("Failed to render template \(error)")
            }
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

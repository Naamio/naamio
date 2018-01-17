import Foundation

import Kitura
import KituraMarkdown

import NaamioCore
import NaamioTemplateEngine

struct Routers {
    
    let view: Router

    init() {
        view = Router()
        
        // Set default view path to template path.
        view.viewsPath = Templating.default.path
    }
}

/**
 Routes provides the mechanism for defining routes through
 context.
 */
class Routes {

    static let routers = Routers()

    static let naamioTemplateEngine = NaamioTemplateEngine()
    
    class func defineRoutes() {
        let router = Routes.routers.view      
        
        var name: String?
        
        defineAuthMiddleware() 
        defineHeadersMiddleware()
        defineTemplateRoutes()
        definePostsRoutes()
        defineAssetsRoutes()
        defineContentRoutes()
        
        try! naamioTemplateEngine.cacheTemplates(from: "\(Config.settings["naamio.templates"] as! String)")
        
        /*
        if (FileManager.default.fileExists(atPath: sourcePath)) {
            router.all("/", middleware: StaticFileServer(path: sourcePath))
        }*/
        
        router.setDefault(templateEngine: naamioTemplateEngine)
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

        print("\(Templating.default.templates!.routable.count) templates found")
        
        for template in Templating.default.templates!.routable {
            let templateName = NSString(string: template.name).deletingPathExtension
            
            print("Routing template '\(template.source!)/\(templateName)'")
            
            router.get("\(template.source!)/\(templateName)") { request, response, next in
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
        
        defineExceptionalRoutes()
    }

    class func defineAuthMiddleware() {
        // This route executes the echo middleware
        Routes.routers.view.all(middleware: BasicAuthMiddleware())
    }

    class func defineHeadersMiddleware() {
        Routes.routers.view.all("/*", middleware: HeadersMiddleware())
    }

    class func defineTemplateRoutes() {
        let templatesPath = Config.settings["naamio.templates"] as! String

        if (FileManager.default.fileExists(atPath: templatesPath)) {
            Log.info("Templates folder '\(templatesPath)' found. Loading templates")
            Routes.routers.view.setDefault(templateEngine: naamioTemplateEngine)
        }
    }

    private func definePagesRoutes() {
        let sourcePath = Config.settings["naamio.source"] as! String
        let pagesPath = sourcePath + "_/pages"

        if (FileManager.default.fileExists(atPath: pagesPath)) {
            Log.info("Pages folder '\(pagesPath)' found. Loading pages at '/'")
        }
    }

    class func definePostsRoutes() {
        let sourcePath = Config.settings["naamio.source"] as! String
        let postsPath = sourcePath + "_/posts"

        if (FileManager.default.fileExists(atPath: postsPath)) {
            Log.info("Posts folder '\(postsPath)' found. Loading posts at '/posts'")
        }
    }

    class func defineAssetsRoutes() {
        let sourcePath = Config.settings["naamio.source"] as! String
        let assetsPath = sourcePath + "/assets"

        if (FileManager.default.fileExists(atPath: assetsPath)) {
            Log.info("Assets folder '\(assetsPath)' found. Loading static file server at '/assets'")
            Routes.routers.view.all("/assets", middleware: StaticFileServer(path: assetsPath))
        }
    }

    class func defineContentRoutes() {
        let sourcePath = Config.settings["naamio.source"] as! String

        if (FileManager.default.fileExists(atPath: sourcePath + "/content")) {
            Log.info("Content folder /content found. Loading static file server at '/content'")
            Routes.routers.view.all("/", middleware: StaticFileServer(path: sourcePath + "/content"))
        }
    }

    class func defineStaticRoutes() {

    }

    class func defineExceptionalRoutes() {
        // Handles any errors that get set
        Routes.routers.view.error { request, response, next in
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
        Routes.routers.view.all { request, response, next in
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

    init() {
        self.definePagesRoutes()
    }
}

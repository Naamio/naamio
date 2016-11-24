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
import KituraMustache

import LoggerAPI
import HeliumLogger

func defineRoutes(router: Router) {
    // Variable to post/put data to.
    var name: String?

    // This route executes the echo middleware
    router.all(middleware: BasicAuthMiddleware())

    router.all("/static", middleware: StaticFileServer())

    router.get("/hello") { _, response, next in
        response.headers["content-type"] = "text/plain; charset=utf-8"
        let fName = name ?? "World"
        try response.send("Hello \(fName), from Omnijar!").end()
    }

    // This route accepts POST requests
    router.post("/hello") {request, response, next in 
        response.headers["content-type"] = "text/plain; charset=utf-8"
        name = try request.readString()
        try response.send("Got a POST request").end()
    }

    // This route accepts DELETE requests
    router.delete("/hello") {request, response, next in
        response.headers["content-type"] = "text/plain; charset=utf-8"
        name = nil
        try response.send("Got a DELETE request").end()
    }

    // Error handling example
    router.get("/error") { _, response, next in 
        Log.error("Example of error being set")
        response.status(.internalServerError)
        response.error = NSError(domain: "RouterTestDomain", code: 1, userInfo: [:])
        next()
    }

    // Redirection example
    router.get("/redir") { _, response, next in 
        try response.redirect("http://www.ibm.com")
        next()
    }

    // Reading parameters
    // Accepts user as a parameter
    router.get("/users/:user") { request, response, next in 
        response.headers["content-type"] = "text/html"
        let p1 = request.parameters["user"] ?? "(nil)"
        try response.send(
            "<!DOCTYPE html><html><body>" + 
            "<b>User:</b> \(p1)" + 
            "</body></html>\n\n").end()
    }

    // Uses multiple handler blocks
    router.get("/multi", handler: { request, response, next in 
        response.send("I'm here!\n")
        next()
    }, { request, response, next in 
        response.send("Me too!\n")
        next()
    })
    router.get("/multi") { request, response, next in 
        try response.send("I come afterward...\n").end()
    }

    // Support for Mustache implemented for OSX only yet
    #if !os(Linux)
    router.setDefault(templateEngine: MustacheTemplateEngine())

    router.get("/trimmer") { _, response, next in
        defer {
            next()
        }

        var context: [String: Any] = [
            "name": "Arthur",
            "date": NSDate(),
            "realDate": NSDate().addingTimeInterval(60*60*24*3),
            "late": true
        ]

        // Let template format dates with `{{format(...)}}`
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        context["format"] = dateFormatter

        try response.render("document", context: context).end()
    }
    #endif

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
                try response.status(.notFound).send("Route not found in application!").end()
            }
        } 
        next()
    }
}
import KituraContracts
import Kitura

import NaamioCore

class RouteHandler {
    func getPage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let path = request.route else {
            // FIXME: Custom errors needed for RouteHandler.
            return
        }
        
        print("Template route '\(path)'")
        defer {
            next()
        }
        do {
            let context: [String: Any] = [
                "meta": [
                    "title": "Naamio"
                ],
                "page": [
                    "title": "Naamio"
                ],
                "partials": [
                    "header": true,
                    "footer": true
                ]
            ]
            
            try response.render(".\(path)", context: context).end()
        } catch {
            print("Couldn't render '\(path)': \(error)")
            Log.error("Failed to render template \(error)")
        }
    }
//(name: Name, completion: (Name?, Error?) -> Void) {
    func getPost(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        
    }


}

struct Page: Codable, Identifier {
    
    var value: String
    
    init(value: String) throws {
        self.value = value
    }
    
}

struct Post: Codable {
    
}

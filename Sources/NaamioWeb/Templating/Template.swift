import Foundation

import Malline

enum RouteType: String {
    case id = "id"
    case page
    case root = "index"
}

protocol TemplateCachable {
    
    var template: Template { get set }
    
    var stencil: Stencil { get set }
}

struct Template {
    
    let name: String
    
    let location: String?

    var nameWithoutExtension: String {
        return NSString(string: self.name).deletingPathExtension
    }

    var routeAs: RouteType {
        get {
            guard let routeAs = RouteType(rawValue: self.nameWithoutExtension) else {
                return .page
            }

            return routeAs
        }
    }
}

struct TemplateCachedItem: TemplateCachable {
    
    var template: Template
    
    var stencil: Stencil
}

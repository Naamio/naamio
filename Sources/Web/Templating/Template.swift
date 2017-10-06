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
    
    var name: String {
        get {
            return NSString(string: self.fileName).deletingPathExtension
        }
    }
    
    let location: String?
    
    let fileName: String

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

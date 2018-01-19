import Malline

protocol TemplateCachable {
    
    var template: Template { get set }
    
    var stencil: Stencil { get set }
}

struct Template {
    
    let name: String
    
    let location: String?
}

struct TemplateCachedItem: TemplateCachable {
    
    var template: Template
    
    var stencil: Stencil
}

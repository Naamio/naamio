import Malline

protocol StencilCachable {
    
    var template: Template { get set }
    
    var stencil: Stencil { get set }
}

struct Template {
    
    let name: String
    
    let location: String?
}

struct TemplateCachedItem: StencilCachable {
    
    var template: Template
    
    var stencil: Stencil
}

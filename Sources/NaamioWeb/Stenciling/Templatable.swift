

protocol Templatable {
    
    var base: String { get }
    
    var extensions: [String] { get }

    var layouts: [Template] { get set }
    
    var partials: [Template] { get set }
    
    var routable: [Template] { get set }

}

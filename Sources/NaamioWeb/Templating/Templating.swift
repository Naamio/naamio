import Foundation

import NaamioCore
import NaamioTemplateEngine

import Malline



/// Templating provides the tools necessary to take content
/// and provide it in a structured method to the end-user.
class Templating {
    
    static let `default` = Templating()
    
    let engine = NaamioTemplateEngine()
    
    /// List of templates within Templating instance.
    var templates: Templatable?
    
    var cache: [TemplateCachable]?
    
    var path: String {
        get {
            return (templates?.base)!
        }
    }
    
    init() {
        let path = Config.settings["naamio.stencils"] as? String ?? "_stencils"
        
        do {
            templates = try TemplateLoader(withPath: path).load()
            try self.cacheTemplates()
        } catch {
            print("Cannot load templates")
        }
        
    }
    
    private func cacheTemplates() throws {
        print("Caching templates")

        let _ = try templates?.routable.map( {
            try cacheTemplate(template: $0)
        } )
    }
    
    private func cacheTemplate( template: Template) throws {
        print("Caching " + path + template.location! + "/" + template.name)
        let stencil: Stencil = try engine.cacheTemplate(filePath: path + template.location! + "/" + template.name)
        cache?.append(TemplateCachedItem(template: template, stencil: stencil))
    }
}

import Foundation

import NaamioCore

import Malline

/// Templating provides the tools necessary to take content
/// and provide it in a structured method to the end-user.
class Templating {
    
    static let `default` = Templating()
    
    /// List of templates within Templating instance.
    var templates: Templatable?
    
    /// The path of the templates.
    var path: String = ""
    
    init() {
        /*path = Config.settings["naamio.templates"] as? String ?? "_templates"
         
         templates = try! Path(path).recursiveChildren()
         .filter({ $0.extension == templateSuffix })
         .map { normalizeTemplatePath(from: $0) }*/
        path = Config.settings["naamio.templates"] as? String ?? "_templates"
        
        do {
            templates = try TemplateLoader(withPath: path).load()
        } catch {
            print("Cannot load templates")
        }
    }
    
    func normalizeTemplatePath(from path:Path) -> String {
        let resources = Resources()
        
        return resources.getResources(from: path.string)
    }
}

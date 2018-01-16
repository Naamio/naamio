import Foundation

import NaamioCore

import Malline
import ViilaFS

struct Template {
    var name: String
    var source: String?
}

/// Templating provides the tools necessary to take content
/// and provide it in a structured method to the end-user.
class Templating {
    
    static let `default` = Templating()
    
    private let templateSuffix = "html"
    
    /// List of templates within Templating instance.
    var templates: [Template] = [Template]()
    
    /// The path of the templates.
    var path: String = ""
    
    init() {
        /*path = Config.settings["naamio.templates"] as? String ?? "_templates"
        
        templates = try! Path(path).recursiveChildren()
            .filter({ $0.extension == templateSuffix })
            .map { normalizeTemplatePath(from: $0) }*/
        registerApp()
    }
    
    func normalizeTemplatePath(from path:Path) -> String {
        let resources = Resources()
        
        return resources.getResources(from: path.string)
    }
    
    func registerApp() {
        path = Config.settings["naamio.templates"] as? String ?? "_templates"
        
        do {
            let folder = try Folder(path: path)
            
            self.registerTemplateFolder(folder)
            self.registerTemplates(folder)
        } catch {
            print("Templates (\(path)) could not be loaded")
        }
    }
    
    func registerTemplateFolder(_ folder: Folder) {
        print("Registering template folder \(folder.name)")
        let _ = folder.subfolders
            .filter { !$0.name.hasPrefix("_") }
            .map { registerTemplateFolder( $0 ) }
        
        let _ = folder.subfolders
            .filter { !$0.name.hasPrefix("_") }
            .map { registerTemplates( $0 ) } 
    }
    
    func registerTemplates(_ folder: Folder) {
        print("Registering templates folder \(folder.name)")
        let _ = folder.files
            .filter({ $0.extension == templateSuffix })
            .map({ registerTemplate(fromFile: $0 ) })
    }
    
    func registerTemplate(fromFile file: File) {
        switch file.nameExcludingExtension {
        case "id":
            registerQueryableTemplate(file)
        case "index":
            registerRootTemplate(file)
        default:
            registerSingleTemplate(file)
        }
    }
    
    func registerQueryableTemplate(_ file: File) {
        print("Queryable template is \(file.name)")
        templates.append(Template(name: file.name, source: file.path))
    }
    
    func registerRootTemplate(_ file: File) {
        print("Root template is \(file.name)")
        templates.append(Template(name: file.name, source: file.path))
    }
    
    func registerSingleTemplate(_ file: File) {
        print("Single template is \(file.name)")
        templates.append(Template(name: file.name, source: file.path))
    }
}

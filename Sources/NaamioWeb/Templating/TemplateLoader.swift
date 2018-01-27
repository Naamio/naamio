import ViilaFS

/// Loads templates
class TemplateLoader {
    
    private var templates:Templatable

    init(withPath path: String) {
        self.templates = TemplateSet(from: path)
    }
    
    func load() throws -> Templatable {
        print("Loading templates from '\(templates.base)'")

        self.registerTemplateFolder(fromPath: "")
        self.registerTemplates(fromPath: "")
        
        return templates
    }
    
    func registerTemplateFolder(fromPath path: String) {
        do {
            let folder = try Folder(path: templates.base + path)
            
            print("Registering template folder '\(folder.name)'")
            let _ = folder.subfolders
                .filter { !$0.name.hasPrefix("_") }
                .map { registerTemplateFolder( fromPath: "\(path)\($0.name)" ) }
            
            let _ = folder.subfolders
                .filter { !$0.name.hasPrefix("_") }
                .map { registerTemplates( fromPath: "\(path)\($0.name)" ) }
        } catch {
            print("Templates (\(path)) could not be loaded")
        }
    }
    
    func registerTemplates(fromPath path: String) {
        let fullPath = "\(templates.base)\(path)"
        print("Registering templates from path '\(path)' (at '\(fullPath)')")
        
        do {
            let folder = try Folder(path: fullPath)
            
            let _ = try folder.files
                .filter({ templates.extensions.contains($0.extension!) })
                .map({ try registerTemplate($0.name, fromPath: path ) })
        } catch {
            print("Templates at '\(path)' could not be loaded")
        }
    }
    
    func registerTemplate(_ name: String, fromPath path: String) throws {
        print("Registering template '\(name)' from '\(path)'")
        let file = try File(path: "\(templates.base)\(path)/\(name)")
        
        switch file.nameExcludingExtension {
        case "id":
            registerQueryableTemplate(file, fromPath: path)
        case "index":
            registerRootTemplate(file, fromPath: path)
        default:
            registerSingleTemplate(file, fromPath: path)
        }
    }
    
    func registerTemplate(_ file: File, fromPath path: String) {
        print("Template is \(file.name)")
        templates.routable.append(Template(location: path, fileName: file.name))
    }
    
    func registerQueryableTemplate(_ file: File, fromPath path: String) {
        print("Queryable template is \(file.name)")
        templates.routable.append(Template( location: path, fileName: file.name))
    }
    
    func registerRootTemplate(_ file: File, fromPath path: String) {
        print("Root template is \(file.name)")

        let newPath = (path.hasPrefix("/") || (path.count == 0)) ? path : "/\(path)"

        templates.routable.append(Template(location: newPath, fileName: file.name))
    }
    
    func registerSingleTemplate(_ file: File, fromPath path: String) {
        print("Single template is \(file.name) at \(path)")
        
        let newPath = (path.hasPrefix("/") || (path.count == 0)) ? path : "/\(path)"
        
        templates.routable.append(Template(location: newPath, fileName: file.name))
    }
}

private class TemplateSet: Templatable {
    let base: String
    
    let extensions: [String]
    
    var layouts: [Template]
    
    var partials: [Template]
    
    var routable: [Template]
    
    init(from base: String) {
        self.base = base
        self.extensions = ["html"]
        self.layouts = [Template]()
        self.partials = [Template]()
        self.routable = [Template]()
    }
}

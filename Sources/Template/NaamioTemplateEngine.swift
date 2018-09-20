import Foundation

import Malline

import NaamioCore


/// NaamioTemplateEngine is the base templating system for `Naamio`.
/// It utilizes `Kitura` and `Malline`, extending base functionality 
/// to support additional tags and functions, specific to `Naamio`.
///
/// Documentation can be found at [Malline on GitHub](https://github.com/Naamio/malline).
public class NaamioTemplateEngine {

    /// Identifies the specific file extensions to look for.
    /// In the case of `Naamio`, we use `.html` to simplify
    /// adoption and migration use cases.
    public var fileExtension: String { return "html" }

    let `extension`: Extension

    var rootPaths: [Path] = []
    
    private var cache: [TemplateCache]
    
    /// Initializes a new instance of the `NaamioTemplateEngine` with 
    /// the default extension (`.html`).
    public init(extension: Extension = Extension()) {
        self.`extension` = `extension`
        self.cache = [TemplateCache]()
    }
    
    public func cacheTemplates(from path: String) throws {
        Log.trace("Caching templates in \(path)")
        let templates = try! Path(path).recursiveChildren()
        
        for template in templates {
            _ = try self.cacheTemplate(filePath: template.string)
        }
    }

    public func setRootPaths(rootPaths: [String]) {
        self.rootPaths = rootPaths.map { Path($0) }
    }

    /// Caches the template from the URL of the file to enable more rapid 
    /// rendering a less expensive file IO requests for each HTTP request.
    ///
    ///  - Parameters:
    ///    - filePath: The URL of the file as a string.
    ///  - Throws: A rendering Error if the stencil cannot be loaded.
    ///  - Returns: The complete stencil after loading.
    public func cacheTemplate(filePath: String) throws -> Stencil {
        let templatePath = Path("\(filePath).html")
        
        guard templatePath.isFile else {
            throw NaamioTemplateEngineError.notValidTemplate
        }
        
        let templateDirectory = templatePath.parent()
        
        Log.trace("\(templatePath.string) is loading")
        
        let loader = FileSystemLoader(paths: [templateDirectory])
        `extension`.registerTag("asset", parser: AssetTag.parse)
        let environment = Environment(loader: loader, extensions: [`extension`])

        let template = try environment.loadStencil(names: [templatePath.lastComponent])
        Log.trace("Template '\(String(describing: template.name))' loaded")
        
        if cache.contains(where: { cachedItem in
            if (template.name == cachedItem.stencil.name) &&
                (templatePath == cachedItem.path) {
                return true
            } else {
                return false
            }
        }) {
            return template
        }
        else {
            Log.trace("Template is new. Caching.")
            return template
        }
    }
    
    func assetsFilter(value: Any?, arguments: [Any?]) throws -> Any? {
        var path: String
        
        if let value = arguments.first as? String {
            path = value
        } else {
            throw StencilSyntaxError("Asset tag must be called with a String argument")
        }
        
        path = "/assets" + path
        
        /*
            if let value = value as? String {
                return "/assets" + value
            }
        */
        
        return path
    }
}

